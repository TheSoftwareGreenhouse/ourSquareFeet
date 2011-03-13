vows = require 'vows'
assert = require 'assert'
UiLayerModule = require '../../server/public/javascript/uiLayer.coffee'

subscriptions = {
  "remove": []
  "plant/new": []
}
reset = () ->
  for key, value of subscriptions
    subscriptions[key] = []

vows.describe('UiLayer').addBatch({
  'when a new UiLayer is created': {
    topic: () ->
      paper = {
        squareFoot: (coord) -> {
          name: "Mock Square Foot Widget"
          coord: coord
          subscribe: (eventName, toDo) ->
            subscriptions[eventName].push toDo
        }
        plant: () -> {
          name: "Mock Plant Widget"
        }
      }
      new UiLayerModule.UiLayer(paper)
    'then it has an createSquareFootWidget method': (topic) ->
      assert.isFunction topic.createSquareFootWidget
    'then it has an createPlantWidget method': (topic) ->
      assert.isFunction topic.createPlantWidget
    'when creating a Plant widget': {
      topic: (topic) ->
        reset()
        result = {}
        result.widget = topic.createPlantWidget {}
        result.ui = topic
        result
      'then it creates a Plant Widget via the paper': (topic) ->
        assert.equal topic.widget.name, "Mock Plant Widget"
    }
    'when creating a Square Foot widget': {
      topic: (topic) ->
        reset()
        result = {}
        result.widget = topic.createSquareFootWidget {c:1,r:1}
        result.ui = topic
        result
      'then it creates a SquareFootWidget via the paper': (topic) ->
        assert.equal topic.widget.name, "Mock Square Foot Widget"
        assert.equal topic.widget.coord.r, 1
        assert.equal topic.widget.coord.c, 1
      'then it subscribes to the Widgets remove event': (topic) ->
        assert.equal subscriptions["remove"].length, 1
      'then it subscribes to the Widgets new plant event': (topic) ->
        assert.equal subscriptions["plant/new"].length, 1
      'when the widget publishes a new plant  event': {
        topic: (topic) ->
          topic.ui.subscribe "plant/new", this.callback
          subscriptions["plant/new"][0].call null, {coord:{c:1, r:1}}
        'then the plant/new event is published': (err, data) ->
          assert.equal err.coord.r, 1
          assert.equal err.coord.c, 1
      }
#      'when the widget publishes a remove square foot event': {
#        topic: (topic) ->
#          topic.ui.subscribe "squareFoot/delete", this.callback
#          subscriptions["remove"][0].call null, {coord:{c:1, r:1}}
#        'then the squareFoot/delete event is published': (err, data) ->
#          console.log "err #{err}"
#          assert.equal err.coord.r, 1
#          assert.equal err.coord.c, 1
#      }
    }
  }
}).export module
