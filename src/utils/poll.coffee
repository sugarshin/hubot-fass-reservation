ms = require 'ms'
getHtml = require './get-html'
module.exports = (url, comparator, interval = ms('1m')) ->
  timerId = null
  new Promise (resolve, reject) ->
    do f = () ->
      getHtml url
      .then (html) ->
        if comparator html
          clearTimeout timerId
          resolve html
        else
          timerId = setTimeout f, interval
      .catch (err) ->
        clearTimeout timerId
        reject err
