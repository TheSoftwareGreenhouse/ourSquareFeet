http = require "http"
server = require "./lib/node/ourSquareFeet/server/server"

server.listen 8080

console.log "Server running at http://localhost:8080/"
