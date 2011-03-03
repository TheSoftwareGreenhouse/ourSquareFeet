root = exports ? this

LayoutEngine = (config) ->
   _top = config.top
   _bottom = config.bottom
   _left = config.left
   _right = config.right
   _noOfColumns = config.noOfColumns
   _noOfRows = config.noOfRows
   _squareFootGap = config.squareFootGap
   _rowOffset = config.rowOffset
   _columnOffset = config.columnOffset
   _width = Math.abs(_right - _left)
   _height = Math.abs(_bottom - _top)
   _columnWidth = Math.floor(_width/_noOfColumns)
   _rowHeight = Math.floor(_height/_noOfRows)
   _plantWidth = _columnWidth - (2* _squareFootGap)
   _plantHeight = _rowHeight - (2* _squareFootGap)
   _columnLefts = for columnPosition in [0..(_width - _columnWidth)] by _columnWidth
     columnPosition
   _rowTops = for rowPosition in [0..(_height - _rowHeight)] by _rowHeight
     rowPosition
   top: _top
   right: _right
   bottom: _bottom
   left: _left
   noOfColumns: _noOfColumns
   noOfRows: _noOfRows
   squareFootGap: _squareFootGap
   width: _width
   height: _height
   columnWidth: _columnWidth
   rowHeight: _rowHeight
   plantWidth: _plantWidth
   plantHeight: _plantHeight
   columnPositions: _columnLefts[1.._columnLefts.length]
   rowPositions: _rowTops[1.._rowTops.length]
   getLeftForPlantInColumn: (column) ->
     this.getLeftForColumn(column) + _squareFootGap
   getTopForPlantInRow: (row) ->
     this.getTopForRow(row) + _squareFootGap
   getLeftForColumn: (column) ->
     _columnLefts[column + _columnOffset]
   getTopForRow: (row) ->
     _rowTops[row + _rowOffset]
   pixelsToColumn: (x) ->
     Math.floor(x / _columnWidth) - _columnOffset
   pixelsToRow: (y) ->
     Math.floor(y / _rowHeight) - _rowOffset

root.LayoutEngine = LayoutEngine

