vows = require 'vows'
assert = require 'assert'
CoordModule = require '../../server/public/javascript/coord.coffee'

vows.describe('Coord objects').addBatch({
  'when using the Coord class': {
    topic: () -> CoordModule.Coord
    'then the class should have a whatsTopLeft function': (topic) ->
      assert.isFunction topic.whatsTopLeft
    'then the class should have a whatsBottomRight function': (topic) ->
      assert.isFunction topic.whatsBottomRight
    'then the class should workout top left correctly': (topic) ->
      assert.isTrue topic.whatsTopLeft({c:1,r:5}, {c:5,r:1}).matches({c:1,r:1})
    'then the class should workout bottom right correctly': (topic) ->
      assert.isTrue topic.whatsBottomRight({c:1,r:5}, {c:5,r:1}).matches({c:5,r:5})
  }
  'when a new coord is created': {
    topic: () -> new CoordModule.Coord({c:1, r:1})
    'then the coord has a row number': (topic) ->
      assert.isNumber topic.r
    'then the coord has a column number': (topic) ->
      assert.isNumber topic.c
    'then the coord has a matches method': (topic) ->
      assert.isFunction topic.matches
    'then the coord has methods for creating neighbours': (topic) ->
      assert.isFunction topic.above
      assert.isFunction topic.below
      assert.isFunction topic.toTheLeft
      assert.isFunction topic.toTheRight
    'then the coord is correct': (topic) ->
      assert.equal topic.c, 1
      assert.equal topic.r, 1
    'then the coord matches correctly': (topic) ->
      assert.isTrue topic.matches({r:1,c:1})
      assert.isFalse topic.matches({r:0,c:1})
    'then the coord produce neighbours correctly': (topic) ->
      assert.isTrue topic.above().matches({r:0,c:1})
      assert.isTrue topic.below().matches({r:2,c:1})
      assert.isTrue topic.toTheLeft().matches({r:1,c:0})
      assert.isTrue topic.toTheRight().matches({r:1,c:2})
  }
}).export module
