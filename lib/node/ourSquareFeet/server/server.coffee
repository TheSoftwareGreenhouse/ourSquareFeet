http = require 'http'
express = require 'express'

wwwPublicPath = 'server/public'

app = express.createServer()

app.configure () ->
  app.use(express.staticProvider(wwwPublicPath))

app.get '/wannahelp', (req, res) ->
  res.render "wannahelp.jade"

app.get '/', (request, response) ->
  response.render "index.jade"

module.exports = app
