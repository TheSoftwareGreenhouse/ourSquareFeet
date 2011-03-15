config = {
  top: 0
  right: 3000
  bottom: 2000
  left: 0
  noOfColumns: 23
  noOfRows: 15
  squareFootGap: 8
  columnOffset:11
  rowOffset: 7
}

le = LayoutEngine config

sf = new SquareFeet()
plants = new Plants()

Raphael.fn.straightLine = (left, top, width, height) ->
  canvas = this
  canvas.path("M#{left} #{top}L#{left+width} #{top+height}")

Raphael.fn.closeButton = (top, right) ->
  canvas = this
  # calculate layout
  widget = CloseButtonWidget(le, top, right)
  factor = 0.25
  cross = widget.cross
  # build Raphael objects
  rect = canvas.rect(widget.left, widget.top, widget.width, widget.height, 3)
  slashUp = canvas.straightLine(cross.left, cross.top + cross.height, cross.width, -cross.height)
  slashDown = canvas.straightLine(cross.left, cross.top, cross.width, cross.height)
  # format objects
  rect.attr {"fill": "#f00", "fill-opacity": ".2"}
  formatPath = (path) ->
    attributes = {
      "stroke-width": "2"
      "stroke-linecap": "round"
      "stroke": "#222"
    }
    path.attr attributes
  formatPath path for path in [slashUp,slashDown,rect]
  # create a return object
  button =   {
    graphics: {
      rect: rect
      slashUp: slashUp
      slashDown: slashDown
    }
    remove: () ->
      slashUp.remove()
      slashDown.remove()
      rect.remove()
    hide: () ->
      slashUp.hide()
      slashDown.hide()
      rect.hide()
    show: () ->
      slashUp.show()
      slashDown.show()
      rect.attr {opacity: 0}
      rect.show()
      rect.animate {opacity: 1}, 400
  }
  observatory = new Observatory(button)
  # publish
  click = (event) -> observatory.publish "click", "closing"
  graphic.click click for key, graphic of button.graphics
  # subscriptions
  mouseOn = (event) ->
    rect.animate {"fill-opacity": ".8"}, 200
    observatory.publish "mouseOn"
  mouseOff= (event) ->
    rect.animate {"fill-opacity": ".2"}, 200
    observatory.publish "mouseOff"
  graphic.hover mouseOn, mouseOff for key, graphic of button.graphics
  # return
  button

Raphael.fn.squareFoot = (squareFoot) ->
  canvas = this
  # calculate Layout
  left = le.getLeftForColumn(squareFoot.coord.c)
  width = le.columnWidth
  top = le.getTopForRow(squareFoot.coord.r)
  height = le.rowHeight
  closeButtonDim = {
    left:  left + Math.floor(0.8 * width)
    top:   top + Math.floor(0.05 * height)
    width: Math.floor(0.15 * width)
    height:Math.floor(0.15 * height)
  }
  # build Raphael objects
  drawBorder = (from, to) ->
    path = canvas.path "M"+from.x+" "+from.y+"L"+to.x+" "+to.y
  drawTopBorder = () ->
    drawBorder {x:left,y:top}, {x:left+width, y:top}
  drawBottomBorder = () ->
    drawBorder {x:left,y:top+height}, {x:left+width, y:top+height}
  drawLeftBorder = () ->
    drawBorder {x:left,y:top}, {x:left, y:top+height}
  drawRightBorder = () ->
    drawBorder {x:left+width,y:top}, {x:left+width, y:top+height}
  square = canvas.rect(left, top, width, height)
  borders = {
    top:    drawTopBorder()
    bottom: drawBottomBorder()
    left:   drawLeftBorder()
    right:  drawRightBorder()
  }
  closeButton = canvas.closeButton(top, left + width)
  # format Raphael objects
  square.attr("fill", "#999")
  square.attr("fill-opacity", "0.5")
  square.attr("stroke-opacity", "0")
  for key, border of borders
    border.attr("stroke-width", "5")
    border.attr("stroke-linecap", "round")
    border.hide()
  # create a return object
  uiSquareFoot = {
    graphics: {
      square: square
      borders: borders
    }
    children: {
      closeButton: closeButton
    }
    remove: () ->
      closeButton.remove()
      border.remove() for key, border of borders
      square.remove()
    coord: squareFoot.coord
    updateBorders:() ->
      if sf.exists(squareFoot.neighbours.top) then borders.top.hide() else borders.top.show()
      if sf.exists(squareFoot.neighbours.bottom) then borders.bottom.hide() else borders.bottom.show()
      if sf.exists(squareFoot.neighbours.left) then borders.left.hide() else borders.left.show()
      if sf.exists(squareFoot.neighbours.right) then borders.right.hide() else borders.right.show()
  }
  observatory = new Observatory(uiSquareFoot)
  # Publish
  square.click () ->
    if not plants.existsAtCoord(squareFoot.coord) then (
      closeButton.hide()
      observatory.publish "plant/new", squareFoot
    )
  # Subscriptions
  closeButton.subscribe "click", (text) ->
    observatory.publish "remove", squareFoot
  mouseStillInSquare = (event) ->
    if event?
      event = $.event.fix(event)
      inHorizontally = (left < event.pageX < (left + width))
      inVertically = (top < event.pageY < (top + height))
      inHorizontally and inVertically
  mouseOn  = () -> if not plants.existsAtCoord(squareFoot.coord) then closeButton.show()
  mouseOff = (event) -> if not mouseStillInSquare(event) then closeButton.hide()
  square.hover mouseOn, mouseOff
  # initialise
  uiSquareFoot.updateBorders()
  closeButton.hide()
  mouseOn
  uiSquareFoot

Raphael.fn.grid = () ->
  canvas = this
  square = canvas.rect(le.left,le.top,le.width,le.height)
  square.attr("stroke-width", "5")
  square.attr("fill", "#fdfdfd")
  drawGridLine = (pathString) ->
    path = canvas.path(pathString)
    path.attr("stroke-dasharray", "- ")
  drawColumnLine = (columnLinePosition) ->
    drawGridLine "M"+ columnLinePosition + " 0L" + columnLinePosition + " " + le.height
  drawRowLine = (rowLinePosition) ->
    drawGridLine "M0 " + rowLinePosition + "L" + le.width + " " + rowLinePosition
  drawColumnLine colPos for colPos in le.columnPositions
  drawRowLine rowPos for rowPos in le.rowPositions
  square

Raphael.fn.plant = (plant) ->
  canvas = this
  widget = new PlantWidget(le, plant)
  # draw primivites
  widget.addRect canvas.rect(widget.left, widget.top, widget.width, widget.height, 6)
  widget.addText canvas.text(widget.centerColumn, widget.centerRow, widget.name)
  widget.applyAttributes {
    rect: {
      "fill": widget.color
      "stroke-width": "3"
    }
    text: {
    "font-size": "20"
    }
  }
  # draw children
  closeButton = canvas.closeButton widget.top, widget.left + widget.width
  widget.addCloseButtonWidget closeButton
  widget

persistance = {}

persistance.squareFeet = [
  {c:-3,r:-1}, {c:-2,r:-1}, {c:-1,r:-1}, {c:0,r:-1}
  {c:-3,r: 0}, {c:-2,r: 0}, {c:-1,r: 0}, {c:0,r: 0}
  {c:-3,r: 1}, {c:-2,r: 1}, {c:-1,r: 1}, {c:0,r: 1}
  {c:-3,r: 2}, {c:-2,r: 2}, {c:-1,r: 2}, {c:0,r: 2}

  {c: 2,r:-1}, {c: 3,r:-1}, {c: 4,r:-1}
  {c: 2,r: 0}, {c: 3,r: 0}, {c: 4,r: 0}
  {c: 2,r: 1}, {c: 3,r: 1}, {c: 4,r: 1}
]

persistance.plants = [
  {start: {c: 0,r:-1}, end: {c: 0,r:-1}, name:"Brocolli", color:"#008000"}
  {start: {c:-1,r:-1}, end: {c:-1,r:-1}, name:"Spring\nOnion", color:"#00ff7f"}
  {start: {c:-2,r:-1}, end: {c:-2,r:-1}, name:"French\nBean",  color:"#008000"}
  {start: {c:-3,r:-1}, end: {c:-3,r:-1}, name:"French\nBean", color:"#008000"}
  {start: {c: 0,r: 0}, end: {c: 0,r: 0}, name:"Spring\nOnion", color:"#00ff7f"}
  {start: {c:-1,r: 0}, end: {c:-1,r: 0}, name:"Chives", color:"#00ff7f"}
  {start: {c:-2,r: 0}, end: {c:-2,r: 0}, name:"French\nBean", color:"#008000"}
  {start: {c:-3,r: 0}, end: {c:-3,r: 0}, name:"French\nBean", color:"#008000"}
  {start: {c: 0,r: 1}, end: {c: 0,r: 1}, name:"Lettuce", color:"#00ff7f"}
  {start: {c:-1,r: 1}, end: {c:-1,r: 1}, name:"Lettuce", color:"#00ff7f"}
  {start: {c:-2,r: 1}, end: {c:-2,r: 1}, name:"Lettuce", color:"#00ff7f"}
  {start: {c:-3,r: 1}, end: {c:-3,r: 1}, name:"Marigold", color:"#ffff00"}
  {start: {c: 0,r: 2}, end: {c: 0,r: 2}, name:"Lettuce", color:"#00ff7f"}
  {start: {c:-1,r: 2}, end: {c:-1,r: 2}, name:"Carrot", color:"#ffa500"}
  {start: {c:-2,r: 2}, end: {c:-2,r: 2}, name:"Carrot", color:"#ffa500"}
  {start: {c:-3,r: 2}, end: {c:-3,r: 2}, name:"Carrot", color:"#ffa500"}
  {start: {c: 4,r: 1}, end: {c: 4,r: 1}, name:"Carrot", color:"#ffa500"}
  {start: {c: 3,r: 1}, end: {c: 3,r: 1}, name:"Carrot", color:"#ffa500"}
  {start: {c: 2,r: 1}, end: {c: 2,r: 1}, name:"Carrot", color:"#ffa500"}
  {start: {c: 3,r: 0}, end: {c: 4,r: 0}, name:"Zuchini", color:"#008045"}
  {start: {c: 2,r: 0}, end: {c: 2,r: 0}, name:"Marigold", color:"#ffff00"}
  {start: {c: 4,r:-1}, end: {c: 4,r:-1}, name:"Brocolli", color:"#008000"}
  {start: {c: 3,r:-1}, end: {c: 3,r:-1}, name:"Spring\nOnion", color:"#00ff7f"}
  {start: {c: 2,r:-1}, end: {c: 2,r:-1}, name:"Marigold", color:"#ffff00"}
]

paper = Raphael("canvas")
ui = new UiLayer(paper)

# REMINDER: move the grid into the UiLayer
grid = paper.grid()
$(grid.node).bind "click", (event) ->
  c = le.pixelsToColumn(event.pageX)
  r = le.pixelsToRow(event.pageY)
  squareFoot = sf.add {c:c, r:r}

# REMINDER: create Model Layer for sf and plants

plants.subscribe "new", (plant) ->
  ui.createPlantWidget plant
  console.log "There are #{ui.plants.length} plant widgets"

plants.subscribe "deleted", (plant) ->
  ui.removePlantWidget plant
  console.log "There are #{ui.plants.length} plant widgets"

sf.subscribe "new", (squareFoot) ->
  ui.createSquareFootWidget squareFoot
  # REMINDER: move updateBordersOf into ui Layer
  updateBordersOf squareFoot.coord

ui.subscribe "plant/new", (squareFoot) ->
  plants.add {
    start: squareFoot.coord
    end:   squareFoot.coord
    name:" New Plant"
    color: "#fff"
  }

ui.subscribe "plant/delete", (plant) ->
  plants.remove plant.start

ui.subscribe "squareFoot/delete", (squareFoot) ->
  sf.remove squareFoot.coord

# REMINDER: The ui object should handle this event
sf.subscribe "removed", (coord) ->
  uiSquareFoot = (foot for foot in ui.squareFeet when (foot.coord.matches(coord)))[0]
  ui.squareFeet = (foot for foot in ui.squareFeet when not (foot.coord.matches(coord)))
  uiSquareFoot.remove()
  updateBordersOf coord


updateBordersOf = (coord) ->
  getUiSquareFoot = (coord) ->
    matches = (foot for foot in ui.squareFeet when (coord.matches(foot.coord)))
    if matches.length is 1 then matches[0] else null
  neighbours = {
    top: coord.above()
    bottom: coord.below()
    left: coord.toTheLeft()
    right: coord.toTheRight()
  }
  for position, neighbour of neighbours
    squareFootUi = getUiSquareFoot neighbour
    squareFootUi.updateBorders() if squareFootUi isnt null

sf.add squareFoot for squareFoot in persistance.squareFeet

plants.add plant for plant in persistance.plants

height = $(window).height()
width = $(window).width()
window.scrollTo(1500-(width/2), 1000-(height/2))

$().ready () ->
  $(".help a").bind 'click', (event) ->
    $("aside.message").animate {marginLeft: '25%'}, 1000
    event.preventDefault()
  $("button.close").bind 'click', (event) ->
    $("aside.message").animate {marginLeft: '120%'}, 1000
  $("#oops").animate {marginLeft: '25%'}, 1000

