vows = require 'vows'
assert = require 'assert'
SquareFootModule = require '../../server/public/javascript/squarefoot.coffee'

vows.describe('SquareFoot').addBatch({
  'when a new SquareFoot is created': {
    topic: () ->
      sf = new SquareFootModule.SquareFoot({c:1, r:1})
    'then the SquareFoot has an containsPlant method': (topic) ->
      assert.isFunction topic.containsPlant
    'then the SquareFoot has coordinates object': (topic) ->
      assert.isObject topic.coord
    'then the SquareFoot has neighbours object': (topic) ->
      assert.isObject topic.neighbours
      assert.isObject topic.neighbours.top
      assert.isObject topic.neighbours.bottom
      assert.isObject topic.neighbours.left
      assert.isObject topic.neighbours.right
    'then the coord are correct': (topic) ->
      assert.equal topic.coord.c, 1
      assert.equal topic.coord.r, 1
    'then the neighbours are correct': (topic) ->
      assert.isTrue topic.neighbours.top.matches({c:1,r:0})
      assert.isTrue topic.neighbours.bottom.matches({c:1,r:2})
      assert.isTrue topic.neighbours.left.matches({c:0,r:1})
      assert.isTrue topic.neighbours.right.matches({c:2,r:1})
  }
}).export module
