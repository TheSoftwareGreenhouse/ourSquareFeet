vows = require 'vows'
assert = require 'assert'
SquareFeet = require '../../server/public/javascript/squarefeet.coffee'

vows.describe('SquareFeet').addBatch({
  'when adding a square feet': {
    topic: () ->
      sf = new SquareFeet.SquareFeet()
      {squareFoot: sf.add({c:1,r:1}), squareFeet: sf}
    'then we get back a foot': (topic) ->
      assert.equal topic.squareFoot.c, 1
      assert.equal topic.squareFoot.r, 1
    'then the coordinate exists': (topic) ->
      assert.isTrue topic.squareFeet.exists {c:1,r:1}
    'then the coord at (0,0) doesnt exist': (topic) ->
      assert.isFalse topic.squareFeet.exists {c:0, r:0}
  }
  'when adding more than one square foot': {
    topic: () ->
      sf = new SquareFeet.SquareFeet()
      sf.add {c:1,r:1}
      sf.add {c:2,r:1}
      sf.add {c:3,r:1}
      sf.add {c:4,r:1}
      sf
    'then the coordinates exist': (topic) ->
      assert.isTrue topic.exists {c:1,r:1}
      assert.isTrue topic.exists {c:2,r:1}
      assert.isTrue topic.exists {c:3,r:1}
      assert.isTrue topic.exists {c:4,r:1}
    'then the coord at (0,0) doesnt exist': (topic) ->
      assert.isFalse topic.exists {c:0, r:0}
  }
}).export module
