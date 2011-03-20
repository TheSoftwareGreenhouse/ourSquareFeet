helpers = require '../testHelpers'
vows = helpers.vows
assert = helpers.assert
jQuery = helpers.jQuery
recorderMock = helpers.recorderMock
executeSubscribers = helpers.executeSubscribers

EditableTextWidget = (require '../../server/public/javascript/ui/editableTextWidget.coffee').EditableTextWidget


vows.describe('EditableTextWidget').addBatch({
  'when a new EditableTextWidget is created': {
    topic: () ->
      mocks = {}
      mocks.inputBox = {}
      jQuery.bind.__returns (call) ->
        mocks.inputBox
      mocks.text = recorderMock "dblclick", "hide", "getBBox", "show"
      mocks.text.getBBox.__returns () ->
        {
          width: 50
          height: 50
        }
      mocks.canvas = {
        text: () -> mocks.text
      }
      {
        mocks: mocks
        sut: new EditableTextWidget(mocks.canvas, 100, 100, "Chives")
        actuals: {}
      }
    'then the widget has a hover function': (topic) ->
      assert.isFunction topic.sut.hover
    'then the widget has an onChange function': (topic) ->
      assert.isFunction topic.sut.onChange
    'then the widget has an attr function': (topic) ->
      assert.isFunction topic.sut.attr
    'then the widget has a remove function': (topic) ->
      assert.isFunction topic.sut.remove
     # test functionality
    'then the inputBox has been hidden': (topic) ->
      assert.hasBeenCalled jQuery.hide
    'then the text has a subscriber to its dblclick event': (topic) ->
      assert.isFunction topic.mocks.text.dblclick.__calls[0].arguments[0]
    'then the text has supplied its dimensions': (topic) ->
      assert.hasBeenCalled topic.mocks.text.getBBox
    'and the hover event has been set': {
      topic: (topic) ->
        topic.mocks.mouseOver = () ->
        topic.mocks.mouseOut = () ->
        topic.mocks.text.hover = (mouseOver, mouseOut) ->
          topic.mocks.text.mouseOver = mouseOver
          topic.mocks.text.mouseOut = mouseOut
        topic.mocks.text.mouseOver = null
        topic.mocks.text.mouseOut = null
        topic.sut.hover topic.mocks.mouseOver, topic.mocks.mouseOut
        topic
      'then the text hover event is set': (topic) ->
        assert.equal topic.mocks.text.mouseOver, topic.mocks.mouseOver
        assert.equal topic.mocks.text.mouseOut, topic.mocks.mouseOut
      'and the text has been double-clicked': {
        topic: (topic) ->
          executeSubscribers topic.mocks.text.dblclick, 0
          topic
        'then the text is hidden': (topic) ->
          assert.hasBeenCalled topic.mocks.text.hide
        'then the inputBox is moved and resized': (topic) ->
          assert.wasCalledWith jQuery.css, ['top',    50]
          assert.wasCalledWith jQuery.css, ['left',   50]
          assert.wasCalledWith jQuery.css, ['width',  100]
          assert.wasCalledWith jQuery.css, ['height', 100]
        'then the inputBox is shown': (topic) ->
          assert.hasBeenCalled jQuery.show
        'then the inputBox has the value of text': (topic) ->
          assert.wasCalledWith jQuery.val, ["Chives"]
        'then the inputBox has focus': (topic) ->
          assert.hasBeenCalled jQuery.focus
        'then the inputBox has had a subscriber to blur event': (topic) ->
          assert.equal  jQuery.bind.__calls[0].arguments[0], 'blur'
          assert.isFunction  jQuery.bind.__calls[0].arguments[1]
      }
    }
    'and the onChange event is subscribed to': {
      topic: (topic) ->
        topic.actuals.newText = null
        topic.sut.onChange (newText) ->
          topic.actuals.newText = newText
        topic
      'and the inputBox has blurred': {
        topic: (topic) ->
          jQuery.val.__returns (call) ->
            if call.arguments.length == 0 then "Sesame" else call.previous.arguments[0]
          executeSubscribers jQuery.bind, [1]
          topic
        'then the input box is hidden': (topic) ->
          assert.hasBeenCalled jQuery.hide
        'then the blur event is unsubscribed': (topic) ->
          assert.wasCalledWith jQuery.unbind, ["blur"]
        'then the input box returns the new value': (topic) ->
          assert.hasBeenCalled jQuery.val
        'then the input box is emptied': (topic) ->
          assert.wasCalledWith jQuery.val, [null]
        'then the changed name was raised': (topic) ->
          assert.equal topic.actuals.newText, "Sesame"
        'then the text is shown': (topic) ->
          assert.hasBeenCalled topic.mocks.text.show
      }
    }
    'and attributes are applied': {
      topic: (topic) ->
        topic.mocks.attributes = {}
        topic.mocks.text.attributes = null
        topic.mocks.text.attr = (attributes) ->
          topic.mocks.text.attributes = attributes
        topic.sut.attr topic.mocks.attributes
        topic
      'then the attributes are applied to the text': (topic) ->
        assert.equal topic.mocks.text.attributes, topic.mocks.attributes
    }
    'and the widget is removed': {
      topic: (topic) ->
        topic.mocks.text.removed = false
        topic.mocks.text.remove = () ->
          topic.mocks.text.removed = true
        topic.sut.remove()
        topic
      'then the text is also removed': (topic) ->
        assert.isTrue topic.mocks.text.removed
    }
  }
}).addBatch({
  'when a new EditableTextWidget is created with text with spaces': {
    topic: () ->
      mocks = { }
      actuals = {raphael: {}}
      mocks.inputBox = {}
      jQuery.bind.__returns (call) ->
        mocks.inputBox
      mocks.text = recorderMock "dblclick", "hide", "getBBox", "show"
      mocks.text.getBBox.__returns () ->
        {
          width: 50
          height: 50
        }
      mocks.canvas = {
        text: (x, y, text) ->
          actuals.raphael.text = {x:x, y:y, text: text}
          mocks.text
      }
      {
        mocks: mocks
        sut: new EditableTextWidget(mocks.canvas, 100, 100, "Big Fat Chives")
        actuals: actuals
      }
    'then the text is created with the space converted to a new line': (topic) ->
      assert.equal topic.actuals.raphael.text.text, "Big\nFat\nChives"
  }
}).export module
