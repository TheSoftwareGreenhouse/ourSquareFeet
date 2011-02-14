http = require 'http'
express = require 'express'

wwwPublicPath = 'server/public'

app = express.createServer()

app.configure () ->
  app.use(express.staticProvider(wwwPublicPath))

app.get '/', (request, response) ->
  response.render "index.jade"

app.get '*', (request, response) ->
  response.render "oops.jade"

module.exports = app
