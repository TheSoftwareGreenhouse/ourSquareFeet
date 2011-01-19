http = require 'http'
express = require 'express'

app = express.createServer()
app.get '/', (request, response) ->
  response.render "helloworld.haml"

module.exports = app
