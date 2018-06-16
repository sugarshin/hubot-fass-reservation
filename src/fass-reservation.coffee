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
#   hubot fass <salon id> rsv - <reservation> - Reserve.
#
# Author:
#   Shingo Sato <shinsugar@gmail.com>

{ toNumber, head, last, isNull, isUndefined } = require 'lodash'
cheerio = require 'cheerio'
poll = require './utils/poll'
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

module.exports = (robot) ->
  robot.respond /\s*fass\s+([a-z0-9]+)\s+r(?:sv|eserve)?\s*/i, (msg) ->
    unless salonMap[msg.match[1].toLowerCase()]
      msg.send "I don't know such a salon: `#{msg.match[1]}`. You can check with `hubot fass list`"
      return
    msg.send 'No implemention yet.'

  robot.respond /\s*fass\s+list\s*/i, (msg) ->
    msg.send Object.keys(salonMap).map((k) -> ["#{salonMap[k]} - #{k}", "  e.g., `hubot fass #{k} w`"].join '\n').join '\n\n'

  robot.respond /\s*fass\s+([a-z0-9]+)\s+w(?:aiting)?(?:\s+(\d+))?\s*/i, (msg) ->
    unless salonMap[msg.match[1].toLowerCase()]
      msg.send "I don't know such a salon: `#{msg.match[1]}`. You can check with `hubot fass list`"
      return
    if isUndefined msg.match[2]
      getHtml(getWaitingResultPageUrl(msg.match[1]))
      .then (html) ->
        $ = cheerio.load(html)
        if $(selectors.outsideHours).length > 0
          msg.send '営業時間外です'
        else
          msg.send $(selectors.waitingOrder).text()
    else
      numberStr = msg.match[2]
      getHtml(getWaitingResultPageUrl(msg.match[1]))
      .then (html) ->
        waitingOrder = getWaitingOrder html
        if toNumber(last(waitingOrder)[1]) < toNumber(numberStr)
          msg.send 'その番号では予約されていません'
          return
        else if toNumber(head(waitingOrder)[1]) > toNumber(numberStr)
          msg.reply 'すでに来店済みです'
          return
        else
          prevIndex = null
          poll(
            getWaitingResultPageUrl(msg.match[1])
            (html) ->
              currentWaitingOrder = getWaitingOrder html
              if toNumber(head(currentWaitingOrder)[1]) > toNumber(numberStr)
                msg.reply '施術を開始したか、予約が取り消されました'
                return true
              else
                currentIndex = currentWaitingOrder.findIndex((o) -> o[1] is numberStr)
                if currentIndex is 0
                  msg.reply '順番がきました'
                  return true
                else if currentIndex is 3 and (isNull(prevIndex) or currentIndex < prevIndex)
                  msg.reply 'あと 3 人で順番がきます'
                else if currentIndex is 5 and (isNull(prevIndex) or currentIndex < prevIndex)
                  msg.reply 'あと 5 人で順番がきます'
                prevIndex = currentIndex
              return false
          )
          .catch (err) -> msg.send "エラーが発生しました Error: #{err}"
