config = {
  top: 0
  right: 3000
  bottom: 2000
  left: 0
  noOfColumns: 23
  noOfRows: 15
  squareFootGap: 6
}

le = LayoutEngine config

Raphael.fn.grid = () ->
  canvas = this
  drawGridLine = (pathString) ->
    path = canvas.path(pathString)
    path.attr("stroke-dasharray", "- ")
  drawColumnLine = (columnLinePosition) ->
    drawGridLine "M"+ columnLinePosition + " 0L" + columnLinePosition + " " + le.height()
  drawRowLine = (rowLinePosition) ->
    drawGridLine "M0 " + rowLinePosition + "L" + le.width() + " " + rowLinePosition
  drawColumnLine colPos for colPos in [le.columnWidth()..le.width()] by le.columnWidth()
  drawRowLine rowPos for rowPos in [le.rowHeight()..le.height()] by le.rowHeight()

  square = canvas.rect(le.left,le.right,le.top,le.bottom)
  square.attr("stroke-width", "5")

Raphael.fn.plant = (start, end, name, color) ->
  canvas = this
  left = le.getSquareFootLeftForColumn(start.column)
  footWidth = end.column - start.column + 1
  width = ((footWidth-1) * le.columnWidth()) + le.squareFootWidth()
  top = le.getSquareFootTopForRow(start.row)
  footHeight = end.row - start.row + 1
  height = ((footHeight-1) * le.rowHeight()) + le.squareFootHeight()
  square = canvas.rect(left,top, width, height, 6)
  square.attr("fill", color)
  square.attr("stroke-width", "3")
  centreOfColumn = left + (width /2)
  centreOfRow = top + (height /2)
  text = canvas.text(centreOfColumn, centreOfRow, name)
  text.attr("font-size", "20")


paper = Raphael("canvas")
paper.grid()

paper.plant({column:8,row:7}, {column:8,row:7}, "Brocolli", "#008000")
paper.plant({column:7,row:7}, {column:7,row:7}, "Spring\nOnion", "#00ff7f")
paper.plant({column:6,row:7}, {column:6,row:7}, "French\nBean", "#008000")
paper.plant({column:5,row:7}, {column:5,row:7}, "French\nBean", "#008000")

paper.plant({column:8,row:8}, {column:8,row:8}, "Spring\nOnion", "#00ff7f")
paper.plant({column:7,row:8}, {column:7,row:8}, "Chives", "#00ff7f")
paper.plant({column:6,row:8}, {column:6,row:8}, "French\nBean", "#008000")
paper.plant({column:5,row:8}, {column:5,row:8}, "French\nBean", "#008000")

paper.plant({column:8,row:9}, {column:8,row:9}, "Lettuce", "#00ff7f")
paper.plant({column:7,row:9}, {column:7,row:9}, "Lettuce", "#00ff7f")
paper.plant({column:6,row:9}, {column:6,row:9}, "Lettuce", "#00ff7f")
paper.plant({column:5,row:9}, {column:5,row:9}, "Marigold", "#ffff00")

paper.plant({column:8,row:10}, {column:8,row:10}, "Lettuce", "#00ff7f")
paper.plant({column:7,row:10}, {column:7,row:10}, "Carrot", "#ffa500")
paper.plant({column:6,row:10}, {column:6,row:10}, "Carrot", "#ffa500")
paper.plant({column:5,row:10}, {column:5,row:10}, "Carrot", "#ffa500")

paper.plant({column:12,row:9}, {column:12,row:9}, "Carrot", "#ffa500")
paper.plant({column:11,row:9}, {column:11,row:9}, "Carrot", "#ffa500")
paper.plant({column:10,row:9}, {column:10,row:9}, "Carrot", "#ffa500")

paper.plant({column:11,row:8}, {column:12,row:8}, "Zuchini", "#008045")
paper.plant({column:10,row:8}, {column:10,row:8}, "Marigold", "#ffff00")

paper.plant({column:12,row:7}, {column:12,row:7}, "Brocolli", "#008000")
paper.plant({column:11,row:7}, {column:11,row:7}, "Spring\nOnion", "#00ff7f")
paper.plant({column:10,row:7}, {column:10,row:7}, "Marigold", "#ffff00")

height = $(window).height()
width = $(window).width()
window.scrollTo(1500-(width/2), 1000-(height/2))
