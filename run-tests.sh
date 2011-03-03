#!/bin/sh
./bin/node ./test/vows/environment/check-modules.js
./bin/vows ./test/vows/server/server-test.coffee
./bin/vows ./test/unit/layoutengine-test.coffee
./bin/vows ./test/unit/squarefeet-test.coffee

