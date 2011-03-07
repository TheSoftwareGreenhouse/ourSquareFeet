#!/bin/sh
./bin/node ./test/vows/environment/check-modules.js
./bin/vows ./test/vows/server/server-test.coffee
./bin/vows ./test/unit/rectangle-test.coffee
./bin/vows ./test/unit/layoutengine-test.coffee
./bin/vows ./test/unit/squarefeet-test.coffee
./bin/vows ./test/unit/squarefoot-test.coffee
./bin/vows ./test/unit/coord-test.coffee
./bin/vows ./test/unit/plant-test.coffee
./bin/vows ./test/unit/plants-test.coffee
./bin/vows ./test/unit/observatory-test.coffee

