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
   getLeftForPlantInColumn: (column) ->
     this.getLeftForColumn(column) + _squareFootGap
   getTopForPlantInRow: (row) ->
     this.getTopForRow(row) + _squareFootGap
   getLeftForColumn: (column) ->
     (column + _columnOffset) * _columnWidth
   getTopForRow: (row) ->
     (row + _rowOffset) * _rowHeight

root.LayoutEngine = LayoutEngine

