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
      {
        mocks: {plant: plant}
        widget: new PlantWidgetModule.PlantWidget(mockLayoutEngine, plant)
      }
    'then the plant has a name': (topic) ->
      assert.isString topic.widget.name
    'then the plant has a color': (topic) ->
      assert.isString topic.widget.color
    'then the plant widget has a represents function': (topic) ->
      assert.isFunction topic.widget.represents
    'then the plant has a top': (topic) ->
      assert.isNumber topic.widget.top
    'then the plant has a left': (topic) ->
      assert.isNumber topic.widget.left
    'then the plant has a width': (topic) ->
      assert.isNumber topic.widget.width
    'then the plant has a height': (topic) ->
      assert.isNumber topic.widget.height
    'then the widget has a children collection': (topic) ->
      assert.isObject topic.widget.children
    'then the widget has an add close Button method': (topic) ->
      assert.isFunction topic.widget.addCloseButtonWidget
    'then the widget has a subscribe method': (topic) ->
      assert.isFunction topic.widget.subscribe
    'then the widget has a remove method': (topic) ->
      assert.isFunction topic.widget.remove
    'then the widget has a primitives collection': (topic) ->
      assert.isObject topic.widget.primitives
    'then the widget has a addRect function': (topic) ->
      assert.isFunction topic.widget.addRect
    'then the widget has a addText function': (topic) ->
      assert.isFunction topic.widget.addText
    'the the widget has a applyAttributes function': (topic) ->
      assert.isFunction topic.widget.applyAttributes
     # test functionality
    'then the name is correct': (topic) ->
      assert.equal topic.widget.name, "Zuchini"
    'then the color is correct': (topic) ->
      assert.equal topic.widget.color, "#008045"
    'then the widget represents the plant': (topic) ->
      assert.isTrue topic.widget.represents(topic.mocks.plant)
    'then the top is correct': (topic) ->
      assert.equal topic.widget.top, 105
    'then the left is correct': (topic) ->
      assert.equal topic.widget.left, 105
    'then the width is correct': (topic) ->
      assert.equal topic.widget.width, 190
    'then the height is correct': (topic) ->
      assert.equal topic.widget.height, 90
    'then the centre of the row is correct': (topic) ->
      assert.equal topic.widget.centerRow, 150
    'then the centre of the column is correct': (topic) ->
      assert.equal topic.widget.centerColumn, 200
    'when adding a close button widget': {
      topic: (topic) ->
        closeButtonWidget = {
          subscriptions: {}
          subscribedTo: (eventName) ->
           @.subscriptions[eventName] != undefined
          subscribe: (eventName, action) -> @.subscriptions[eventName] = action
          publish: (eventName) -> @.subscriptions[eventName].call(null)
          removed: false
          remove: () -> @.removed = true
          hidden: false
          hide: () -> @.hidden = true
        }
        topic.mocks.closeButtonWidget = closeButtonWidget
        topic.widget.addCloseButtonWidget closeButtonWidget
        topic
      "then the widget has subscribed to close button widget's click event": (topic) ->
        assert.isTrue topic.mocks.closeButtonWidget.subscribedTo('click')
      "then the widget hides the close button widget": (topic) ->
        assert.isTrue topic.mocks.closeButtonWidget.hidden
      "when the close button is clicked": {
        topic: (topic) ->
          plant = undefined
          topic.widget.subscribe "delete", (result) -> plant = result
          topic.mocks.closeButtonWidget.publish 'click'
          plant
        "then the delete event is raised by the plant": (topic)->
          assert.equal topic.name, "Zuchini"
      }
      "when the rect is added to the widget": {
        topic: (topic) ->
          topic.mocks.rect = {
            onMouseOver: null
            onMouseOut: null
            hover: (over, out) ->
              @.onMouseOut = out
              @.onMouseOver = over
          }
          topic.widget.addRect topic.mocks.rect
          topic
        "then the rect exists in the primitives": (topic) ->
          assert.equal topic.widget.primitives.rect, topic.mocks.rect
        "the the hover event is set": (topic) ->
          assert.isNotNull topic.mocks.rect.onMouseOver
          assert.isNotNull topic.mocks.rect.onMouseOut
        "when the text is added to the widget": {
          topic: (topic) ->
            topic.mocks.text = {
              onMouseOver: null
              onMouseOut: null
              hover: (over, out) ->
                @.onMouseOut = out
                @.onMouseOver = over
            }
            topic.widget.addText topic.mocks.text
            topic
          "then the text exists in the primitives": (topic) ->
            assert.equal topic.widget.primitives.text, topic.mocks.text
          "the the hover event is set": (topic) ->
            assert.isNotNull topic.mocks.text.onMouseOver
            assert.isNotNull topic.mocks.text.onMouseOut
          "when the rect and the text have no attributes": {
            topic: (topic) ->
              topic.mocks.rect.newAttr = null
              topic.mocks.rect.attr = (attr) -> @.newAttr = attr
              topic.mocks.text.newAttr = null
              topic.mocks.text.attr = (attr) -> @.newAttr = attr
              topic
            "when attributes are applied" : {
              topic: (topic) ->
                topic.mocks.textAttr = {}
                topic.mocks.rectAttr = {}
                topic.widget.applyAttributes {
                  rect: topic.mocks.rectAttr
                  text: topic.mocks.textAttr
                }
                topic
              "then the rect has new attributes": (topic) ->
                assert.equal topic.mocks.rect.newAttr, topic.mocks.rectAttr
              "then the text has new attributes": (topic) ->
                assert.equal topic.mocks.text.newAttr, topic.mocks.textAttr
            }
          }
          "when the plant widget is to be removed": {
            topic: (topic) ->
              topic.mocks.rect.removed = false
              topic.mocks.rect.remove = () -> @.removed = true
              topic.mocks.text.removed = false
              topic.mocks.text.remove = () -> @.removed = true
              topic.widget.remove()
              topic
            "then the rect is removed": (topic) ->
              assert.isTrue topic.mocks.rect.removed
            "then the text is removed": (topic) ->
              assert.isTrue topic.mocks.text.removed
            "then the close button is removed": (topic) ->
              assert.isTrue topic.mocks.closeButtonWidget.removed
          }
        }
      }
    }
  }
}).export module
