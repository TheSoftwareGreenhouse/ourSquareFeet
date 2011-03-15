Observatory = if exports? then require('./../observatory').Observatory else this.Observatory

root = exports ? this

PlantWidget = (layoutEngine, plant) ->
  le = layoutEngine
  # calculate layout
  start = plant.start
  end = plant.end
  name = plant.name
  color = plant.color
  columnWidth = le.columnWidth
  rowHeight = le.rowHeight
  left = le.getLeftForPlantInColumn(start.c)
  footWidth = end.c - start.c + 1
  width = ((footWidth-1) * columnWidth) + le.plantWidth
  top = le.getTopForPlantInRow(start.r)
  footHeight = end.r - start.r + 1
  height = ((footHeight-1) * rowHeight) + le.plantHeight
  centerOfColumn = left + (width /2)
  centerOfRow = top + (height /2)
  #
  _primitives = {}
  _children = {}
  widget = {
    top: top
    left: left
    width: width
    height: height
    centerRow: centerOfRow
    centerColumn: centerOfColumn
    color: color
    name: name
    children: _children
    represents: (anotherPlant) ->
      anotherPlant == plant
    primitives: _primitives
    addRect: (rect) ->
     rect.hover _mouseOver, _mouseOut
     _primitives.rect = rect
    addText: (text) ->
     text.hover _mouseOver, _mouseOut
     _primitives.text = text
    applyAttributes: (attributes) ->
      for primitive, attribute of attributes
        _primitives[primitive].attr attribute
  }
  mouseStillInPlant = (event) ->
    if event?
      event = $.event.fix(event)
      inHorizontally = (left < event.pageX < (left + width))
      inVertically = (top < event.pageY < (top + height))
      inHorizontally and inVertically
  #Reactions to events
  _mouseOver = () ->
    _children.closeButton.show() if _children.closeButton?
  _mouseOut = (event) ->
    _children.closeButton.hide() if _children.closeButton? and not mouseStillInPlant(event)
  #Events to publish
  _observatory = new Observatory(widget)
  widget.addCloseButtonWidget = (closeButtonWidget) ->
    _children.closeButton = closeButtonWidget
    _children.closeButton.subscribe "click", () ->
      _observatory.publish "delete", plant
    _children.closeButton.hide()
  widget.remove = () ->
    _children.closeButton.remove() if _children.closeButton?
    for key, primitive of _primitives
      primitive.remove()
  widget

root.PlantWidget = PlantWidget