ms = require 'ms'
module.exports = (asyncFunc, comparator, interval = ms('1m')) -> (args...) ->
  timerId = null
  new Promise (resolve, reject) ->
    do f = () ->
      asyncFunc(args...)
      .then (result) ->
        if comparator result
          clearTimeout timerId
          resolve result
        else
          timerId = setTimeout f, interval
      .catch (err) ->
        clearTimeout timerId
        reject err
