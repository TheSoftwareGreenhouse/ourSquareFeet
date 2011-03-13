vows = require 'vows'
assert = require 'assert'
PlantWidgetModule = require '../../server/public/javascript/ui/plantWidget.coffee'

vows.describe('PlantWidget').addBatch({
  'when a new PlantWidget is created': {
    topic: () ->
      mockLayoutEngine = {
        getLeftForPlantInColumn: () -> 105
        columnWidth: 100
        plantWidth: 90
        getTopForPlantInRow: () -> 105
        rowHeight: 100
        plantHeight: 90
      }
      plant = {start: {c: 3,r: 0}, end: {c: 4,r: 0}, name:"Zuchini", color:"#008045"}
      new PlantWidgetModule.PlantWidget(mockLayoutEngine, plant)
    'then the plant has a name': (topic) ->
      assert.isString topic.name
    'then the plant has a color': (topic) ->
      assert.isString topic.color
    'then the plant has a top': (topic) ->
      assert.isNumber topic.top
    'then the plant has a left': (topic) ->
      assert.isNumber topic.left
    'then the plant has a width': (topic) ->
      assert.isNumber topic.width
    'then the plant has a height': (topic) ->
      assert.isNumber topic.height
    'then the name is correct': (topic) ->
      assert.equal topic.name, "Zuchini"
    'then the color is correct': (topic) ->
      assert.equal topic.color, "#008045"
    'then the top is correct': (topic) ->
      assert.equal topic.top, 105
    'then the left is correct': (topic) ->
      assert.equal topic.left, 105
    'then the width is correct': (topic) ->
      assert.equal topic.width, 190
    'then the height is correct': (topic) ->
      assert.equal topic.height, 90
    'then the centre of the row is correct': (topic) ->
      assert.equal topic.centerRow, 150
    'then the centre of the column is correct': (topic) ->
      assert.equal topic.centerColumn, 200
  }
}).export module
