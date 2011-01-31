(function() {
  var LayoutEngine, root;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  LayoutEngine = function(config) {
    var _bottom, _left, _noOfColumns, _noOfRows, _right, _squareFootGap, _top;
    _top = config.top;
    _bottom = config.bottom;
    _left = config.left;
    _right = config.right;
    _noOfColumns = config.noOfColumns;
    _noOfRows = config.noOfRows;
    _squareFootGap = config.squareFootGap;
    return {
      top: _top,
      right: _right,
      bottom: _bottom,
      left: _left,
      noOfColumns: _noOfColumns,
      noOfRows: _noOfRows,
      squareFootGap: _squareFootGap,
      width: function() {
        return this.right - this.left;
      },
      height: function() {
        return this.bottom - this.top;
      },
      columnWidth: function() {
        return Math.floor(this.width() / this.noOfColumns);
      },
      rowHeight: function() {
        return Math.floor(this.height() / this.noOfRows);
      },
      squareFootWidth: function() {
        return this.columnWidth() - (2 * this.squareFootGap);
      },
      squareFootHeight: function() {
        return this.rowHeight() - (2 * this.squareFootGap);
      },
      getSquareFootLeftForColumn: function(column) {
        return (column * this.columnWidth()) + this.squareFootGap;
      },
      getSquareFootTopForRow: function(row) {
        return (row * this.rowHeight()) + this.squareFootGap;
      }
    };
  };
  root.LayoutEngine = LayoutEngine;
}).call(this);
