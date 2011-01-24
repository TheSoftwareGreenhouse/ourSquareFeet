vows = require 'vows'
assert = require 'assert'
shims = require './shims'

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
      assert.include res, '<html>'
      assert.include res, '<h1>Hello World</h1>'
      assert.include res, '</html>'
    'The response contains gets the less-js js file': (err, res) ->
      assert.include res, '<script src="/javascript/less-1.0.21.min.js">'
    'The response contains a link to the main stylesheet': (err, res) ->
      assert.include res, 'href="/stylesheets/main.less"'
  }
  'when serving less-js': {
    topic: () -> getResponse('/javascript/less-1.0.21.min.js', this.callback)
    'The response is less-js': (err, res) ->
      assert.include res, 'LESS - Leaner CSS'
  }
  'when serving up some less stylesheets': {
    topic: () -> getResponse('/stylesheets/main.less', this.callback)
    'The response is the main stylesheet': (err, res) ->
      assert.include res, 'Our Square Feet Main stylesheet'
  }
}).export module
