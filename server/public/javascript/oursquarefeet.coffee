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

Raphael.fn.grid = () ->
  canvas = this
  drawGridLine = (pathString) ->
    path = canvas.path(pathString)
    path.attr("stroke-dasharray", "- ")
  drawColumnLine = (columnLinePosition) ->
    drawGridLine "M"+ columnLinePosition + " 0L" + columnLinePosition + " " + le.height
  drawRowLine = (rowLinePosition) ->
    drawGridLine "M0 " + rowLinePosition + "L" + le.width + " " + rowLinePosition
  drawColumnLine colPos for colPos in le.columnPositions
  drawRowLine rowPos for rowPos in le.rowPositions
  square = canvas.rect(le.left,le.right,le.top,le.bottom)
  square.attr("stroke-width", "5")

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

Raphael.fn.bed = (bed) ->
  canvas = this
  start = bed.start
  end = bed.end
  left = le.getLeftForColumn(start.c)
  footWidth = end.c - start.c + 1
  width = footWidth * le.columnWidth
  top = le.getTopForRow(start.r)
  footHeight = end.r - start.r + 1
  height = footHeight * le.rowHeight
  square = canvas.rect(left, top, width, height)
  square.attr("fill", "#999")
  square.attr("fill-opacity", "0.5")
  square.attr("stroke-width", "5")

paper = Raphael("canvas")
paper.grid()

persistance = {}
persistance.beds = [
  {start: {c:-3,r:-1}, end: {c: 0,r: 2}}
  {start: {c: 2,r:-1}, end: {c: 4,r: 1}}
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

paper.bed bed for bed in persistance.beds
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
