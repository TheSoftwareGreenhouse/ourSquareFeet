vows = require 'vows'
assert = require 'assert'
CloseButtonWidgetModule = require '../../server/public/javascript/ui/closeButtonWidget.coffee'

vows.describe('closeButtonWidget').addBatch({
  'when a new Close Button Widget is created': {
    topic: () ->
      mockLayoutEngine = {
        columnWidth: 100
        rowHeight: 100
      }
      new CloseButtonWidgetModule.CloseButtonWidget(mockLayoutEngine, 100, 100)
    'then the close button has left': (topic) ->
      assert.isNumber topic.left
    'then the close button has top': (topic) ->
      assert.isNumber topic.top
    'then the close button has width': (topic) ->
      assert.isNumber topic.width
    'then the close button has height': (topic) ->
      assert.isNumber topic.height
    'then the close button has dimensions for the cross': (topic) ->
      assert.isObject topic.cross
      assert.isNumber topic.cross.left
      assert.isNumber topic.cross.top
      assert.isNumber topic.cross.width
      assert.isNumber topic.cross.height
    'then the close buttons left is correct': (topic) ->
      assert.equal topic.left, 100 - 15 - 5
    'then the close buttons top is correct': (topic) ->
      assert.equal topic.top, 100 + 5
    'then the close buttons width is correct': (topic) ->
      assert.equal topic.width, 15
    'then the close buttons height is correct': (topic) ->
      assert.equal topic.height, 15
    'then the close buttons left is correct': (topic) ->
      assert.equal topic.left, 100 - 15 - 5
    "then the cross's left is correct": (topic) ->
      assert.equal topic.cross.left, 80 + 3
    "then the cross's top is correct": (topic) ->
      assert.equal topic.cross.top, 105 + 3
    "then the cross's width is correct": (topic) ->
      assert.equal topic.cross.width, 9
    "then the cross's height is correct": (topic) ->
      assert.equal topic.cross.height, 9
  }
}).export module
