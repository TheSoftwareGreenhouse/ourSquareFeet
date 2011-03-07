vows = require 'vows'
assert = require 'assert'
RectangleModule = require '../../server/public/javascript/rectangle.coffee'

vows.describe('Rectangle').addBatch({
  'when a new Rectangle is created': {
    topic: () -> new RectangleModule.Rectangle({c:1, r:5},{c:5, r:1})
    'then the rectangle has a start coord': (topic) ->
      assert.isObject topic.start
    'then the rectangle has a end coord': (topic) ->
      assert.isObject topic.end
    'then the rectangle has a containsCoord method': (topic) ->
      assert.isFunction topic.containsCoord
    'then the start should be 1,1': (topic) ->
      assert.isTrue topic.start.matches({c:1,r:1})
    'then the start should be 5,5': (topic) ->
      assert.isTrue topic.end.matches({c:5,r:5})
    'then the rectangle should work out what it contains correctly': (topic) ->
      assert.isTrue topic.containsCoord({c:3,r:3})
      assert.isTrue topic.containsCoord({c:1,r:1})
      assert.isTrue topic.containsCoord({c:5,r:5})
      assert.isFalse topic.containsCoord({c:0,r:1})
      assert.isFalse topic.containsCoord({c:5,r:6})
  }
}).export module
