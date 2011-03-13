#Rectangle = if exports? then require('./rectangle').Rectangle else this.Rectangle

root = exports ? this

PlantWidget = (layoutEngine, plant) ->
  le = layoutEngine
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
  centerOfColumn = left + (width /2)
  centerOfRow = top + (height /2)
  {
    top: top
    left: left
    width: width
    height: height
    centerRow: centerOfRow
    centerColumn: centerOfColumn
    color: color
    name: name
  }

root.PlantWidget = PlantWidget