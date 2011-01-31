root = exports ? this

LayoutEngine = (config) ->
   _top = config.top
   _bottom = config.bottom
   _left = config.left
   _right = config.right
   _noOfColumns = config.noOfColumns
   _noOfRows = config.noOfRows
   _squareFootGap = config.squareFootGap
   top: _top
   right: _right
   bottom: _bottom
   left: _left
   noOfColumns: _noOfColumns
   noOfRows: _noOfRows
   squareFootGap: _squareFootGap
   width: () ->
     this.right - this.left
   height: () ->
     this.bottom - this.top
   columnWidth: () ->
     Math.floor(this.width()/this.noOfColumns)
   rowHeight: () ->
     Math.floor(this.height()/this.noOfRows)
   squareFootWidth: () ->
     this.columnWidth() - (2* this.squareFootGap)
   squareFootHeight: () ->
     this.rowHeight() - (2* this.squareFootGap)
   getSquareFootLeftForColumn: (column) ->
     (column * this.columnWidth()) + this.squareFootGap
   getSquareFootTopForRow: (row) ->
     (row * this.rowHeight()) + this.squareFootGap

root.LayoutEngine = LayoutEngine

