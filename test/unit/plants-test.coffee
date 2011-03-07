vows = require 'vows'
assert = require 'assert'
Plants = require '../../server/public/javascript/plants.coffee'

newEventRaised = false

vows.describe('Plants').addBatch({
  'when a new Plants collection is created': {
    topic: () -> new Plants.Plants()
    'then the collection has an add method': (topic) ->
      assert.isFunction topic.add
    'then the collection has a existsAtCoord method': (topic) ->
      assert.isFunction topic.existsAtCoord
    'when a plant is added': {
      topic: (topic) ->
        plantJson = {start: {c: 3,r: 0}, end: {c: 4,r: 0}, name:"Zuchini", color:"#008045"}
        topic.subscribe "new", () -> newEventRaised = true
        topic.add plantJson
        topic
      'then the plant should exists at both start and end': (topic) ->
        assert.isTrue topic.existsAtCoord({c:3, r:0})
        assert.isTrue topic.existsAtCoord({c:4, r:0})
      'then the plants collection raised the new event': (topic) ->
        assert.isTrue newEventRaised
    }
  }
}).export module
