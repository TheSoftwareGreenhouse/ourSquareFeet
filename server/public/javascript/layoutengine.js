(function() {
  var LayoutEngine, root;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  LayoutEngine = function(config) {
    var columnPosition, rowPosition, _bottom, _columnLefts, _columnOffset, _columnWidth, _height, _left, _noOfColumns, _noOfRows, _plantHeight, _plantWidth, _right, _rowHeight, _rowOffset, _rowTops, _squareFootGap, _top, _width;
    _top = config.top;
    _bottom = config.bottom;
    _left = config.left;
    _right = config.right;
    _noOfColumns = config.noOfColumns;
    _noOfRows = config.noOfRows;
    _squareFootGap = config.squareFootGap;
    _rowOffset = config.rowOffset;
    _columnOffset = config.columnOffset;
    _width = Math.abs(_right - _left);
    _height = Math.abs(_bottom - _top);
    _columnWidth = Math.floor(_width / _noOfColumns);
    _rowHeight = Math.floor(_height / _noOfRows);
    _plantWidth = _columnWidth - (2 * _squareFootGap);
    _plantHeight = _rowHeight - (2 * _squareFootGap);
    _columnLefts = (function() {
      var _ref, _results;
      _results = [];
      for (columnPosition = 0, _ref = _width - _columnWidth; (0 <= _ref ? columnPosition <= _ref : columnPosition >= _ref); columnPosition += _columnWidth) {
        _results.push(columnPosition);
      }
      return _results;
    })();
    _rowTops = (function() {
      var _ref, _results;
      _results = [];
      for (rowPosition = 0, _ref = _height - _rowHeight; (0 <= _ref ? rowPosition <= _ref : rowPosition >= _ref); rowPosition += _rowHeight) {
        _results.push(rowPosition);
      }
      return _results;
    })();
    return {
      top: _top,
      right: _right,
      bottom: _bottom,
      left: _left,
      noOfColumns: _noOfColumns,
      noOfRows: _noOfRows,
      squareFootGap: _squareFootGap,
      width: _width,
      height: _height,
      columnWidth: _columnWidth,
      rowHeight: _rowHeight,
      plantWidth: _plantWidth,
      plantHeight: _plantHeight,
      columnPositions: _columnLefts.slice(1, (_columnLefts.length + 1) || 9e9),
      rowPositions: _rowTops.slice(1, (_rowTops.length + 1) || 9e9),
      getLeftForPlantInColumn: function(column) {
        return this.getLeftForColumn(column) + _squareFootGap;
      },
      getTopForPlantInRow: function(row) {
        return this.getTopForRow(row) + _squareFootGap;
      },
      getLeftForColumn: function(column) {
        return _columnLefts[column + _columnOffset];
      },
      getTopForRow: function(row) {
        return _rowTops[row + _rowOffset];
      },
      pixelsToColumn: function(x) {
        return Math.floor(x / _columnWidth) - _columnOffset;
      },
      pixelsToRow: function(y) {
        return Math.floor(y / _rowHeight) - _rowOffset;
      }
    };
  };
  root.LayoutEngine = LayoutEngine;
}).call(this);
