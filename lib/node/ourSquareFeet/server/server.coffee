http = require "http"

server = http.createServer (request, response) ->
  response.writeHead 200, {"Content-Type": "text/plain"}
  response.end "Hello World!\n"

module.exports = server
