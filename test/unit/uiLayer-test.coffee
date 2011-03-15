vows = require 'vows'
assert = require 'assert'
ObservatoryModule = require '../../server/public/javascript/observatory.coffee'
UiLayerModule = require '../../server/public/javascript/uiLayer.coffee'

vows.describe('UiLayer').addBatch({
  'when a new UiLayer is created': {
    topic: () ->
      plant = {name: "Mock Plant"}
      plantWidget = {
        name: "Mock Plant Widget"
        plant: plant
        removed: false
        remove: () -> @.removed = true
        represents: (aPlant) -> plant == aPlant
      }
      plantWidget.observatory = new ObservatoryModule.Observatory(plantWidget)

      squareFootWidget = {
        name: "Mock Square Foot Widget"
      }
      squareFootWidget.observatory = new ObservatoryModule.Observatory(squareFootWidget)

      paper = {
        squareFoot: () -> squareFootWidget
        plant: () -> plantWidget
      }
      {
        uiLayer: new UiLayerModule.UiLayer(paper)
        plant: plant
        plantWidget: plantWidget
        squareFootWidget: squareFootWidget
      }
    'then it has an createSquareFootWidget method': (topic) ->
      assert.isFunction topic.uiLayer.createSquareFootWidget
    'then it has an createPlantWidget method': (topic) ->
      assert.isFunction topic.uiLayer.createPlantWidget
    'then it has an removePlantWidget method': (topic) ->
      assert.isFunction topic.uiLayer.removePlantWidget
    'when creating a Plant widget': {
      topic: (topic) ->
        topic.widget = topic.uiLayer.createPlantWidget {}
        topic
      'then it creates a Plant Widget via the paper': (topic) ->
        assert.equal topic.widget, topic.plantWidget
      'then the widget is in the plants collection': (topic) ->
        assert.include topic.uiLayer.plants, topic.plantWidget
      "when the Plant Widget publishes a delete event": {
        topic: (topic) ->
          plantWidget = undefined
          topic.uiLayer.subscribe "plant/delete", (result) -> plantWidget = result
          topic.plantWidget.observatory.publish "delete", topic.plantWidget
          {
            actualPlantWidget: plantWidget
            expectedPlantWidget: topic.plantWidget
          }
        "then the widget raises a delete plant event": (topic) ->
          assert.isNotNull topic.actualPlantWidget
        "then the correct plant is raised": (topic) ->
          assert.equal topic.actualPlantWidget, topic.expectedPlantWidget
      }
      "when removing a Plant Widget": {
        topic: (topic) ->
          topic.uiLayer.removePlantWidget topic.plant
          topic
        "then the plantWidget is not in the plants collection": (topic) ->
          matches = (widget for widget in topic.uiLayer.plants when (widget.plant == topic.plantWidget.plant))
          assert.equal matches.length, 0
        "then the plan wigdet is asked to be removed": (topic) ->
          assert.isTrue topic.plantWidget.removed
      }
    }
    'when creating a Square Foot widget': {
      topic: (topic) ->
        {
          widget: topic.uiLayer.createSquareFootWidget {c:1,r:1}
          uiLayer: topic.uiLayer
          squareFootWidget: topic.squareFootWidget
        }
      'then it creates a SquareFootWidget via the paper': (topic) ->
        assert.equal topic.widget, topic.squareFootWidget
      'then the squarefeet collection contains the widget': (topic) ->
        assert.include topic.uiLayer.squarefeet, topic.squareFootWidget
      'when the squarefoot widget publishes a new plant event': {
        topic: (topic) ->
          squareFootWidget = undefined
          topic.uiLayer.subscribe "plant/new", (result) ->
            squareFootWidget = result
          topic.squareFootWidget.observatory.publish "plant/new", topic.squareFootWidget
          {
            actualSquareFootWidget: squareFootWidget
            expectedSquareFootWidget: topic.squareFootWidget
          }
        'then the plant/new event is published': (topic) ->
          assert.isNotNull topic.actualSquareFootWidget
        'then the correct squareFoot is published': (topic) ->
          assert.equal topic.expectedSquareFootWidget, topic.actualSquareFootWidget
      }
      'when the square foot widget publishes a delete event': {
        topic: (topic) ->
          squareFootWidget = undefined
          topic.uiLayer.subscribe "squareFoot/delete", (result) ->
            squareFootWidget = result
          topic.squareFootWidget.observatory.publish "remove", topic.squareFootWidget
          {
            actualSquareFoot: squareFootWidget
            expectedSquareFoot: topic.squareFootWidget
          }
        'then the squareFoot/delete event is published': (topic) ->
          assert.isNotNull topic.actualSquareFootWidget
        'then the correct square foot is published': (topic) ->
          assert.equal topic.expectedSquareFootWidget, topic.actualSquareFootWidget
      }
    }
  }
}).export module
