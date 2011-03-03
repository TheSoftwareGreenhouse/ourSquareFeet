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

Raphael.fn.squareFoot = (squareFoot) ->
  canvas = this
  left = le.getLeftForColumn(squareFoot.c)
  width = le.columnWidth
  top = le.getTopForRow(squareFoot.r)
  height = le.rowHeight
  drawBorder = (from, to) ->
    path = canvas.path "M"+from.x+" "+from.y+"L"+to.x+" "+to.y
    path.attr("stroke-width", "5")
    path.attr("stroke-linecap", "round")
    path.hide()
    path
  drawTopBorder = () ->
    drawBorder {x:left,y:top}, {x:left+width, y:top}
  drawBottomBorder = () ->
    drawBorder {x:left,y:top+height}, {x:left+width, y:top+height}
  drawLeftBorder = () ->
    drawBorder {x:left,y:top}, {x:left, y:top+height}
  drawRightBorder = () ->
    drawBorder {x:left+width,y:top}, {x:left+width, y:top+height}
  square = canvas.rect(left, top, width, height)
  square.attr("fill", "#999")
  square.attr("fill-opacity", "0.5")
  square.attr("stroke-opacity", "0")
  borders = {
    top:    drawTopBorder()
    bottom: drawBottomBorder()
    left:   drawLeftBorder()
    right:  drawRightBorder()
  }
  square.borders = borders
  square.updateBorders = () ->
    if sf.exists({c:squareFoot.c, r:squareFoot.r-1}) then borders.top.hide() else borders.top.show()
    if sf.exists({c:squareFoot.c, r:squareFoot.r+1}) then borders.bottom.hide() else borders.bottom.show()
    if sf.exists({c:squareFoot.c-1, r:squareFoot.r}) then borders.left.hide() else borders.left.show()
    if sf.exists({c:squareFoot.c+1, r:squareFoot.r}) then borders.right.hide() else borders.right.show()
  square.updateBorders()
  square.coord = {c:squareFoot.c, r:squareFoot.r}
  square

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
  start = plant.start
  end = plant.end
  name = plant.name
  color = plant.color
  left = le.getLeftForPlantInColumn(start.c)
  footWidth = end.c - start.c + 1
  width = ((footWidth-1) * le.columnWidth) + le.plantWidth
  top = le.getTopForPlantInRow(start.r)
  footHeight = end.r - start.r + 1
  height = ((footHeight-1) * le.rowHeight) + le.plantHeight
  square = canvas.rect(left,top, width, height, 6)
  square.attr("fill", color)
  square.attr("stroke-width", "3")
  centreOfColumn = left + (width /2)
  centreOfRow = top + (height /2)
  text = canvas.text(centreOfColumn, centreOfRow, name)
  text.attr("font-size", "20")

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

ui = {squareFeet:[]}

paper = Raphael("canvas")
grid = paper.grid()
$(grid.node).bind "click", (event) ->
  c = le.pixelsToColumn(event.pageX)
  r = le.pixelsToRow(event.pageY)
  squareFoot = sf.add {c:c, r:r}

$(document).bind "SquareFeet/new", (event, squareFoot) ->
  ui.squareFeet.push paper.squareFoot(squareFoot)
  updateBordersOf squareFoot

updateBordersOf = (coord) ->
  neighbours = [
    {c:coord.c  , r:coord.r-1}
    {c:coord.c  , r:coord.r+1}
    {c:coord.c-1, r:coord.r  }
    {c:coord.c+1, r:coord.r  }
  ]
  getUiSquareFoot = (coord) ->
    matches = (foot for foot in ui.squareFeet when (foot.coord.c == coord.c and foot.coord.r == coord.r))
    if matches.length is 1 then matches[0] else null
  for neighbour in neighbours
    squareFootUi = getUiSquareFoot neighbour
    squareFootUi.updateBorders() if squareFootUi isnt null

sf.add squareFoot for squareFoot in persistance.squareFeet

paper.plant plant for plant in persistance.plants

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
