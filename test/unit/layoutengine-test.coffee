vows = require 'vows'
assert = require 'assert'
LayoutEngine = require '../../server/public/javascript/layoutengine.coffee'

config = {
  top: 0
  right: 100
  bottom: 100
  left: 0
  noOfColumns: 5
  noOfRows: 5
  squareFootGap: 2
}

# console.log LayoutEngine.LayoutEngine(config)

vows.describe('the application Layout Engine').addBatch({
  'when starting the Layout Engine': {
    topic: () -> LayoutEngine.LayoutEngine(config)
    'Left is 0': (topic) ->
      assert.equal topic.left, config.left
    'Right is 100': (topic) ->
      assert.equal topic.right, config.right
    'Top is 0': (topic) ->
      assert.equal topic.top, config.top
    'Bottom is 100': (topic) ->
      assert.equal topic.bottom, config.bottom
    'The no. of columns is 5': (topic) ->
      assert.equal topic.noOfColumns, 5
    'The no. of rows is 5': (topic) ->
      assert.equal topic.noOfRows, 5
    'The gap around a Square Foot is 2': (topic) ->
      assert.equal topic.squareFootGap, 2
    'The height is 100': (topic) ->
      assert.equal topic.height(), 100
    'The width is 100': (topic) ->
      assert.equal topic.width(), 100
    'The column width is 20': (topic) ->
      assert.equal topic.columnWidth(), 20
    'The row height is 20': (topic) ->
      assert.equal topic.rowHeight(), 20
    'The width of a square foot is 16': (topic) ->
      assert.equal topic.squareFootWidth(), 16
    'The height of a square foot is 16': (topic) ->
      assert.equal topic.squareFootHeight(), 16
    'The left of the square foot in column 2 is 42 (0-based)': (topic) ->
      assert.equal topic.getSquareFootLeftForColumn(2), 42
    'The top of the square foot in row 5 is 102 (0-based)': (topic) ->
      assert.equal topic.getSquareFootTopForRow(5), 102
  }
}).export module
