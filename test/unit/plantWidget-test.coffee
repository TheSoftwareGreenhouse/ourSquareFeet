vows = require 'vows'
assert = require 'assert'
ObservatoryModule = require '../../server/public/javascript/observatory.coffee'
PlantWidgetModule = require '../../server/public/javascript/ui/plantWidget.coffee'

vows.describe('PlantWidget').addBatch({
  'when a new PlantWidget is created': {
    topic: () ->
      mocks = {}
      mocks.layoutEngine = {
        getLeftForPlantInColumn: () -> 105
        columnWidth: 100
        plantWidth: 90
        getTopForPlantInRow: () -> 105
        rowHeight: 100
        plantHeight: 90
      }
      mocks.plant = {start: {c: 3,r: 0}, end: {c: 4,r: 0}, name:"Zuchini", color:"#008045"}
      {
        mocks: mocks
        sut: new PlantWidgetModule.PlantWidget(mocks.layoutEngine, mocks.plant)
        actuals: {}
      }
    'then the plant has a name': (topic) ->
      assert.isString topic.sut.name
    'then the plant has a color': (topic) ->
      assert.isString topic.sut.color
    'then the plant widget has an isAt function': (topic) ->
      assert.isFunction topic.sut.isAt
    'then the plant has a top': (topic) ->
      assert.isNumber topic.sut.top
    'then the plant has a left': (topic) ->
      assert.isNumber topic.sut.left
    'then the plant has a width': (topic) ->
      assert.isNumber topic.sut.width
    'then the plant has a height': (topic) ->
      assert.isNumber topic.sut.height
    'then the widget has a children collection': (topic) ->
      assert.isObject topic.sut.children
    'then the widget has an add close Button method': (topic) ->
      assert.isFunction topic.sut.addCloseButtonWidget
    'then the widget has a subscribe method': (topic) ->
      assert.isFunction topic.sut.subscribe
    'then the widget has a remove method': (topic) ->
      assert.isFunction topic.sut.remove
    'then the widget has a primitives collection': (topic) ->
      assert.isObject topic.sut.primitives
    'then the widget has a addRect function': (topic) ->
      assert.isFunction topic.sut.addRect
    'then the widget has a addText function': (topic) ->
      assert.isFunction topic.sut.addText
    'the the widget has a applyAttributes function': (topic) ->
      assert.isFunction topic.sut.applyAttributes
    'the the widget has a onEditName function': (topic) ->
      assert.isFunction topic.sut.onEditName
    'the the widget has a plant property': (topic) ->
      assert.isObject topic.sut.plant
     # test functionality
    'then the name is correct': (topic) ->
      assert.equal topic.sut.name, "Zuchini"
    'then the color is correct': (topic) ->
      assert.equal topic.sut.color, "#008045"
    'then the widget is at the plant start and end': (topic) ->
      assert.isTrue topic.sut.isAt(topic.mocks.plant.start)
      assert.isTrue topic.sut.isAt(topic.mocks.plant.end)
    'then the top is correct': (topic) ->
      assert.equal topic.sut.top, 105
    'then the left is correct': (topic) ->
      assert.equal topic.sut.left, 105
    'then the width is correct': (topic) ->
      assert.equal topic.sut.width, 190
    'then the height is correct': (topic) ->
      assert.equal topic.sut.height, 90
    'then the centre of the row is correct': (topic) ->
      assert.equal topic.sut.centerRow, 150
    'then the centre of the column is correct': (topic) ->
      assert.equal topic.sut.centerColumn, 200
    'then the plant is correct': (topic) ->
      assert.equal topic.sut.plant, topic.mocks.plant
    'and a close button widget is added': {
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
        topic.sut.addCloseButtonWidget closeButtonWidget
        topic
      "then the widget has subscribed to close button widget's click event": (topic) ->
        assert.isTrue topic.mocks.closeButtonWidget.subscribedTo('click')
      "then the widget hides the close button widget": (topic) ->
        assert.isTrue topic.mocks.closeButtonWidget.hidden
      "and the close button widget is clicked": {
        topic: (topic) ->
          topic.actuals.plant = null
          topic.sut.subscribe "delete", (result) -> topic.actuals.plant = result
          topic.mocks.closeButtonWidget.publish 'click'
          topic
        "then the delete event is raised by the plant": (topic)->
          assert.isNotNull topic.actuals.plant
      }
      "and a rect is added to the widget": {
        topic: (topic) ->
          topic.mocks.rect = {
            onMouseOver: null
            onMouseOut: null
            hover: (over, out) ->
              @.onMouseOut = out
              @.onMouseOver = over
          }
          topic.sut.addRect topic.mocks.rect
          topic
        "then the rect exists in the primitives": (topic) ->
          assert.equal topic.sut.primitives.rect, topic.mocks.rect
        "the the hover event is set": (topic) ->
          assert.isNotNull topic.mocks.rect.onMouseOver
          assert.isNotNull topic.mocks.rect.onMouseOut
        "and the text is added to the widget": {
          topic: (topic) ->
            topic.mocks.text = {
              onMouseOver: null
              onMouseOut: null
              hover: (over, out) ->
                @.onMouseOut = out
                @.onMouseOver = over
            }
            topic.sut.addText topic.mocks.text
            topic
          "then the text exists in the primitives": (topic) ->
            assert.equal topic.sut.primitives.text, topic.mocks.text
          "then the hover event is set": (topic) ->
            assert.isNotNull topic.mocks.text.onMouseOver
            assert.isNotNull topic.mocks.text.onMouseOut
          "and the rect and the text are set with no attributes": {
            topic: (topic) ->
              topic.mocks.rect.newAttr = null
              topic.mocks.rect.attr = (attr) -> @.newAttr = attr
              topic.mocks.text.newAttr = null
              topic.mocks.text.attr = (attr) -> @.newAttr = attr
              topic
            "and attributes are applied" : {
              topic: (topic) ->
                topic.mocks.textAttr = {}
                topic.mocks.rectAttr = {}
                topic.sut.applyAttributes {
                  rect: topic.mocks.rectAttr
                  text: topic.mocks.textAttr
                }
                topic
              "then the rect has new attributes": (topic) ->
                assert.equal topic.mocks.rect.newAttr, topic.mocks.rectAttr
              "then the text has new attributes": (topic) ->
                assert.equal topic.mocks.text.newAttr, topic.mocks.textAttr
            }
            "and the text raises a changed event": {
              topic: (topic) ->
                # set up mocks
                topic.mocks.newText ="Rosemary"
                topic.mocks.text.observatory = new ObservatoryModule.Observatory(topic.mocks.text)
                topic.mocks.text.onChange = (callback) ->
                  topic.mocks.text.observatory.subscribe "changed", callback
                # prepare actuals
                topic.actuals.newName = null
                # subscribe
                topic.sut.onEditName (newName) ->
                  topic.actuals.newName = newName
                # publish
                topic.mocks.text.observatory.publish "changed", topic.mocks.newText
                topic
              "then the new name is raised on the EditName event": (topic) ->
                assert.equal topic.actuals.newName, topic.mocks.newText
            }
          }
          "and the plant widget is removed": {
            topic: (topic) ->
              topic.mocks.rect.removed = false
              topic.mocks.rect.remove = () -> @.removed = true
              topic.mocks.text.removed = false
              topic.mocks.text.remove = () -> @.removed = true
              topic.sut.remove()
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
