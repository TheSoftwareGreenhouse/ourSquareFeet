Observatory = if exports? then require('./../observatory').Observatory else this.Observatory

$ = if exports? then require("../../../../test/mockjQuery.coffee").jQuery else jQuery

root = exports ? this

EditableTextWidget = (canvas,x,y,text) ->

  _text = {}
  _inputBox = $("input#plantName")
  _createTextBox = (theText) ->
    newText = canvas.text(x,y,theText.replace(/\s/g,"\n"))
    newText.dimension = newText.getBBox()
    newText.originalText = theText
    newText.dblclick (event) ->
      newText.hide()
      left   = x - 50
      top    = y - Math.floor(newText.dimension.height)
      width  = 100
      height = newText.dimension.height * 2
      _inputBox.css('left', left).css('top', top).css('width', width).css('height', height).val(theText).show().focus().bind "blur", (event) ->
        _inputBox.hide()
        _inputBox.unbind "blur"
        newValue = _inputBox.val()
        _inputBox.val(null)
        newText.show()
        _observatory.publish "change", newValue if newValue isnt newText.originalText
    newText

  _text = _createTextBox(text)
  _observatory = new Observatory()
  #
  _inputBox.hide()
  widget = {
    hover:    (onMouseOver, onMouseOut) ->
      _text.hover onMouseOver, onMouseOut
    onChange: (callback) ->
      _observatory.subscribe "change", callback
    attr:     (attributes) ->
      _text.attr attributes
    remove:   () ->
      _text.remove()
  }

root.EditableTextWidget = EditableTextWidget