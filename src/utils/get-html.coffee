request = require 'request-promise-native'
iconv = require 'iconv-lite'
module.exports = (url) ->
  request {
    url
    method: 'GET'
    encoding: null
    transform: (body) -> iconv.decode(body, 'shift_jis')
  }
