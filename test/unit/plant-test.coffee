vows = require 'vows'
assert = require 'assert'
PlantModule = require '../../server/public/javascript/plant.coffee'

vows.describe('Plant').addBatch({
  'when a new Plant is created': {
    topic: () ->
      new PlantModule.Plant({start: {c: 3,r: 0}, end: {c: 4,r: 0}, name:"Zuchini", color:"#008045"})
    'then the plant has a name': (topic) ->
      assert.isString topic.name
    'then the plant has a color': (topic) ->
      assert.isString topic.color
    'then the plant has a start': (topic) ->
      assert.isObject topic.start
    'then the plant has a end': (topic) ->
      assert.isObject topic.end
    'then the plant has an isOnCoord method': (topic) ->
      assert.isFunction topic.isOnCoord
    'then the name is correct': (topic) ->
      assert.equal topic.name, "Zuchini"
    'then the color is correct': (topic) ->
      assert.equal topic.color, "#008045"
    'then the plant is on coords': (topic) ->
      assert.isTrue topic.isOnCoord({c:3,r:0})
      assert.isTrue topic.isOnCoord({c:4,r:0})
      assert.isFalse topic.isOnCoord({c:2,r:0})
    'then the start is correct': (topic) ->
      assert.isTrue topic.start.matches({c:3,r:0})
    'then the end is correct': (topic) ->
      assert.isTrue topic.end.matches({c:4,r:0})
  }
}).export module
