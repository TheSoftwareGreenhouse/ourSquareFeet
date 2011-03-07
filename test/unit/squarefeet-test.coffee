vows = require 'vows'
assert = require 'assert'
SquareFeet = require '../../server/public/javascript/squarefeet.coffee'

vows.describe('SquareFeet').addBatch({
  'when a new SquareFeet is created': {
    topic: () ->
      sf = new SquareFeet.SquareFeet()
    'then the SquareFeet has an add method': (topic) ->
      assert.isFunction topic.add
    'then the SquareFeet has an exists method': (topic) ->
      assert.isFunction topic.exists
    'then the SquareFeet has a remove method': (topic) ->
      assert.isFunction topic.remove
    'when adding a square feet': {
      topic: (topic) ->
        {squareFoot: topic.add({c:1,r:1}), squareFeet: topic}
      'then we get back a foot': (topic) ->
        assert.equal topic.squareFoot.coord.c, 1
        assert.equal topic.squareFoot.coord.r, 1
      'then the coordinate exists': (topic) ->
        assert.isTrue topic.squareFeet.exists {c:1,r:1}
      'then the coord at (0,0) doesnt exist': (topic) ->
        assert.isFalse topic.squareFeet.exists {c:0, r:0}
    }
    'when adding more than one square foot': {
      topic: (sf) ->
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
      'when removing one of the square feet': {
        topic: (topic)->
          topic.remove {c:1, r:1}
          topic
        'then the square foot at (1,1) doesnt exist': (topic) ->
          assert.isFalse topic.exists {c:1,r:1}
      }
    }
  }
}).export module
