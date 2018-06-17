# Description
#   A Hubot script for utilities of FaSS reservation
#
# Configuration:
#   N/A
#
# Commands:
#   hubot fass list - List salons.
#   hubot fass <salon id> waiting - List all waiting.
#   hubot fass <salon id> waiting <number> - Start watch the number in waiting.
#   hubot fass <salon id> reserve - Make a reservation.
#
# Author:
#   Shingo Sato <shinsugar@gmail.com>

{ toNumber, head, last, isNull, isUndefined } = require 'lodash'
cheerio = require 'cheerio'
createPoll = require './utils/create-poll'
getHtml = require './utils/get-html'
salonMap = require './utils/salon-map'

getWaitingResultPageUrl = (salonId) ->
  "https://wb.goku.ne.jp/FaSS#{salonId}HtmlResult/WaitingResultPage.htm"
selectors =
  waitingOrder: 'DIV'
  outsideHours: ':contains("ただいまの時間は営業時間外です")'

###
  @param {String} - text
  @return {['01', '222']}[]
###
parseWaitingOrderText = (text) ->
  text
  .split('\n')
  .filter((t) -> /^\s+(?:\d{2})\)\s+/.test(t))
  .map((t) -> t.trim())
  .map((t) -> t.split(') '))

getWaitingOrder = (html) -> parseWaitingOrderText cheerio.load(html)(selectors.waitingOrder).text()

existsSalon = (msg) ->
  unless salonMap[msg.match[1].toLowerCase()]
    msg.send "I don't know such a salon: `#{msg.match[1]}`. You can check with `hubot fass ls`"
    return false
  return true

module.exports = (robot) ->
  robot.respond /\s*fass\s+l(?:s|ist)\s*$/i, (msg) ->
    msg.send Object.keys(salonMap).map((k) -> ["#{salonMap[k]} - #{k}", "  e.g., `hubot fass #{k} w`"].join '\n').join '\n\n'

  robot.respond /\s*fass\s+([a-z0-9]+)\s+r(?:sv|eserve)\s*$/i, (msg) ->
    return unless existsSalon msg
    msg.send 'Not implemented yet. Please ask https://sugarshin.net/'

  robot.respond /\s*fass\s+([a-z0-9]+)\s+w(?:aiting)?(?:\s+(\d+))?\s*$/i, (msg) ->
    return unless existsSalon msg
    waitingResultPageUrl = getWaitingResultPageUrl msg.match[1]
    getHtml(waitingResultPageUrl)
    .then (html) ->
      $ = cheerio.load(html)
      if $(selectors.outsideHours).length > 0
        msg.send '営業時間外です'
        return
      if isUndefined msg.match[2]
        msg.send $(selectors.waitingOrder).text()
        return

      numberStr = msg.match[2]
      waitingOrder = getWaitingOrder html
      if toNumber(last(waitingOrder)[1]) < toNumber(numberStr)
        msg.send 'その番号では予約されていません'
        return
      if toNumber(head(waitingOrder)[1]) > toNumber(numberStr)
        msg.reply 'すでに来店済みです'
        return

      prevIndex = null
      getHtmlPolling = createPoll(
        getHtml
        (html) ->
          if isNull(prevIndex)
            msg.send "`#{numberStr}` 番の監視を開始します"

          currentWaitingOrder = getWaitingOrder html
          currentIndex = currentWaitingOrder.findIndex((o) -> o[1] is numberStr)
          if (currentIndex is -1) or (toNumber(head(currentWaitingOrder)[1]) > toNumber(numberStr))
            msg.send '施術を開始したか、予約が取り消されました'
            return true

          if currentIndex is 0
            msg.reply '順番がきました'
            return true

          if currentIndex is 3 and (isNull(prevIndex) or currentIndex < prevIndex)
            msg.reply 'あと 3 人で順番がきます'
          else if currentIndex is 5 and (isNull(prevIndex) or currentIndex < prevIndex)
            msg.reply 'あと 5 人で順番がきます'
          prevIndex = currentIndex
          return false
      )
      getHtmlPolling(waitingResultPageUrl).catch (err) -> msg.send "エラーが発生しました #{err.toString()}"
    .catch (err) -> msg.send "エラーが発生しました #{err.toString()}"
