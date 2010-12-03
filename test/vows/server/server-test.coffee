vows = require 'vows'
assert = require 'assert'
shims = require './shims'

#server.listen '8080'

#getResponse = (path, nextStep) ->
#  client = http.createClient '8080'
#  request = client.request path
#  request.end()
#  request.on 'response', (res) ->
#    body = ""
#    res.on 'data', (chunk) ->
#      body += chunk
#    res.on 'end', () ->
#      nextStep null, body

getResponse = shims.getResponse

vows.describe('the Our Square Feet server').addBatch({
  'when querying the server root': {
    topic: () -> getResponse('/', this.callback)
    'There is no error': (err, res) ->
      assert.isNull err
    'The client receives a response': (err, res) ->
      assert.isString res
    'The response is correct': (err, res) ->
      assert.include res, 'Hello World'
  }
}).export module
