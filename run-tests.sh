#!/bin/sh
./bin/node ./test/vows/environment/check-modules.js
./bin/vows ./test/vows/server/server-test.coffee
