vows = require 'vows'
assert = require 'assert'
ObservatoryModule = require '../../server/public/javascript/observatory.coffee'
UiLayerModule = require '../../server/public/javascript/uiLayer.coffee'

vows.describe('UiLayer').addBatch({
  'when a new UiLayer is created': {
    topic: () ->
      mocks = {}
      mocks.plant = {name: "Mock Plant", start: {r:0, c:0} }
      mocks.plantWidget = {
        name: "Mock Plant Widget"
        plant: mocks.plant
        removed: false
        remove: () -> @.removed = true
        isAt: (coord) -> if coord is @.plant.start then true else false
      }
      mocks.plantWidget.observatory = new ObservatoryModule.Observatory(mocks.plantWidget)
      mocks.plantWidget.onEditName  = (callback) ->
        mocks.plantWidget.observatory.subscribe "editName", callback

      mocks.squareFootWidget = {
        name: "Mock Square Foot Widget"
      }
      mocks.squareFootWidget.observatory = new ObservatoryModule.Observatory(mocks.squareFootWidget)

      mocks.paper = {
        squareFoot: () -> mocks.squareFootWidget
        plant: () -> mocks.plantWidget
      }
      {
        sut: new UiLayerModule.UiLayer(mocks.paper)
        mocks: mocks
        actuals: {}
      }
    'then it has an createSquareFootWidget method': (topic) ->
      assert.isFunction topic.sut.createSquareFootWidget
    'then it has an createPlantWidget method': (topic) ->
      assert.isFunction topic.sut.createPlantWidget
    'then it has an removePlantWidget method': (topic) ->
      assert.isFunction topic.sut.removePlantWidget
    'then it has a onEditPlantName method': (topic) ->
      assert.isFunction topic.sut.onEditPlantName
    'when creating a Plant widget': {
      topic: (topic) ->
        topic.actuals.plantWidget = topic.sut.createPlantWidget {}
        topic
      'then it creates a Plant Widget via the paper': (topic) ->
        assert.equal topic.actuals.plantWidget, topic.mocks.plantWidget
      'then the widget is in the plants collection': (topic) ->
        assert.include topic.sut.plants, topic.mocks.plantWidget
      "when the Plant Widget publishes a delete event": {
        topic: (topic) ->
          topic.actuals.plantWidget = null
          topic.sut.subscribe "plant/delete", (result) ->
            topic.actuals.plantWidget = result
          topic.mocks.plantWidget.observatory.publish "delete", topic.mocks.plantWidget
          topic
        "then the widget raises a delete plant event": (topic) ->
          assert.isNotNull topic.actuals.plantWidget
        "then the correct plant is raised": (topic) ->
          assert.equal topic.actuals.plantWidget, topic.mocks.plantWidget
        "and the plant raises an edit name event": {
          topic: (topic) ->
            topic.actuals.plant = null
            topic.actuals.newName = null
            topic.sut.onEditPlantName (plant, newName) ->
              topic.actuals.plant = plant
              topic.actuals.newName = newName
            topic.mocks.newName = "Ginger"
            topic.mocks.plantWidget.observatory.publish "editName", topic.mocks.newName
            topic
          "then the uiLayer raises executes the subscription": (topic) ->
            assert.isNotNull topic.actuals.plant
            assert.isNotNull topic.actuals.newName
          "then the correct plant and new name are raised": (topic) ->
            assert.equal topic.actuals.plant, topic.mocks.plant
            assert.equal topic.actuals.newName, topic.mocks.newName
        }
      }
      "and the Plant Widget is removed": {
        topic: (topic) ->
          topic.sut.removePlantWidget topic.mocks.plant
          topic
        "then the plantWidget is not in the plants collection": (topic) ->
          matches = (widget for widget in topic.sut.plants when (widget.plant == topic.mocks.plant))
          assert.equal matches.length, 0
        "then the plant widget is asked to be removed": (topic) ->
          assert.isTrue topic.mocks.plantWidget.removed
      }
    }
    'when creating a Square Foot widget': {
      topic: (topic) ->
        topic.actuals.squareFootWidget = topic.sut.createSquareFootWidget {c:1,r:1}
        topic
      'then it creates a SquareFootWidget via the paper': (topic) ->
        assert.equal topic.actuals.squareFootWidget, topic.mocks.squareFootWidget
      'then the squarefeet collection contains the widget': (topic) ->
        assert.include topic.sut.squarefeet, topic.mocks.squareFootWidget
      'when the squarefoot widget publishes a new plant event': {
        topic: (topic) ->
          topic.actuals.squareFootWidget = null
          topic.sut.subscribe "plant/new", (result) ->
            topic.actuals.squareFootWidget = result
          topic.mocks.squareFootWidget.observatory.publish "plant/new", topic.mocks.squareFootWidget
          topic
        'then the plant/new event is published': (topic) ->
          assert.isNotNull topic.actuals.squareFootWidget
        'then the correct squareFoot is published': (topic) ->
          assert.equal topic.actuals.squareFootWidget, topic.mocks.squareFootWidget
      }
      'when the square foot widget publishes a delete event': {
        topic: (topic) ->
          topic.actuals.squareFootWidget = null
          topic.sut.subscribe "squareFoot/delete", (result) ->
            topic.actuals.squareFootWidget = result
          topic.mocks.squareFootWidget.observatory.publish "remove", topic.mocks.squareFootWidget
          topic
        'then the squareFoot/delete event is published': (topic) ->
          assert.isNotNull topic.actuals.squareFootWidget
        'then the correct square foot is published': (topic) ->
          assert.equal topic.actuals.squareFootWidget, topic.mocks.squareFootWidget
      }
    }
  }
}).export module
