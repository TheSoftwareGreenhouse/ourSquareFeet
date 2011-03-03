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
    'The left of columns are correct': (topic) ->
      assert.equal topic.getLeftForColumn(-2), 0
      assert.equal topic.getLeftForColumn(-1), 20
      assert.equal topic.getLeftForColumn(0), 40
      assert.equal topic.getLeftForColumn(1), 60
      assert.equal topic.getLeftForColumn(2), 80
    'The top of rows are correct': (topic) ->
      assert.equal topic.getTopForRow(-2), 0
      assert.equal topic.getTopForRow(-1), 20
      assert.equal topic.getTopForRow(0), 40
      assert.equal topic.getTopForRow(1), 60
      assert.equal topic.getTopForRow(2), 80
    'The left of the plants are correct': (topic) ->
      assert.equal topic.getLeftForPlantInColumn(-2), 2
      assert.equal topic.getLeftForPlantInColumn(-1), 22
      assert.equal topic.getLeftForPlantInColumn(0), 42
      assert.equal topic.getLeftForPlantInColumn(1), 62
      assert.equal topic.getLeftForPlantInColumn(2), 82
    'The top of the plants are correct': (topic) ->
      assert.equal topic.getTopForPlantInRow(-2), 2
      assert.equal topic.getTopForPlantInRow(-1), 22
      assert.equal topic.getTopForPlantInRow(0), 42
      assert.equal topic.getTopForPlantInRow(1), 62
      assert.equal topic.getTopForPlantInRow(2), 82
    'The column positions are correct': (topic) ->
      assert.equal topic.columnPositions.length, 4
      assert.equal topic.columnPositions[0], 20
      assert.equal topic.columnPositions[1], 40
      assert.equal topic.columnPositions[2], 60
      assert.equal topic.columnPositions[3], 80
    'The row positions are correct': (topic) ->
      assert.equal topic.rowPositions.length, 4
      assert.equal topic.rowPositions[0], 20
      assert.equal topic.rowPositions[1], 40
      assert.equal topic.rowPositions[2], 60
      assert.equal topic.rowPositions[3], 80
    'Pixels to column is correct': (topic) ->
      assert.equal topic.pixelsToColumn(12), -2
      assert.equal topic.pixelsToColumn(20), -1
      assert.equal topic.pixelsToColumn(59), 0
      assert.equal topic.pixelsToColumn(60), 1
      assert.equal topic.pixelsToColumn(81), 2
    'Pixels to row is correct': (topic) ->
      assert.equal topic.pixelsToRow(12), -2
      assert.equal topic.pixelsToRow(20), -1
      assert.equal topic.pixelsToRow(59), 0
      assert.equal topic.pixelsToRow(60), 1
      assert.equal topic.pixelsToRow(81), 2
  }
}).export module
