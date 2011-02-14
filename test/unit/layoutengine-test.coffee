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
  columnOffset: 2
  rowOffset: 2
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
      assert.equal topic.height, 100
    'The width is 100': (topic) ->
      assert.equal topic.width, 100
    'The column width is 20': (topic) ->
      assert.equal topic.columnWidth, 20
    'The row height is 20': (topic) ->
      assert.equal topic.rowHeight, 20
    'The width of a plant is 16': (topic) ->
      assert.equal topic.plantWidth, 16
    'The height of a plant is 16': (topic) ->
      assert.equal topic.plantHeight, 16
    'The left of column 0 is 40': (topic) ->
      assert.equal topic.getLeftForColumn(0), 40
    'The top of row 0 is 40': (topic) ->
      assert.equal topic.getTopForRow(0), 40
    'The left of the square foot in column 2 is 82': (topic) ->
      assert.equal topic.getLeftForPlantInColumn(2), 82
    'The top of the square foot in row -1 is 22': (topic) ->
      assert.equal topic.getTopForPlantInRow(-1), 22
  }
}).export module
