# Description
#   A Hubot script for utilities of FaSS reservation
#
# Configuration:
#   N/A
#
# Commands:
#   hubot fass waiting - <get turn waiting all>
#   hubot fass waiting N - <get turn waiting N>
#   hubot fass rsv - <reservation>
#
# Notes:
#   N/A
#
# Author:
#   sugarshin <shinsugar@gmail.com>

module.exports = (robot) ->
  robot.respond /fass/, (res) ->
    res.reply "hello!"

  # robot.hear /orly/, (res) ->
  #   res.send "yarly"
