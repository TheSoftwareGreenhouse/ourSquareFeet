(function() {
  var config, height, le, paper, width;
  config = {
    top: 0,
    right: 3000,
    bottom: 2000,
    left: 0,
    noOfColumns: 23,
    noOfRows: 15,
    squareFootGap: 8,
    columnOffset: 11,
    rowOffset: 7
  };
  le = LayoutEngine(config);
  Raphael.fn.grid = function() {
    var canvas, colPos, drawColumnLine, drawGridLine, drawRowLine, rowPos, square, _ref, _ref2, _ref3, _ref4;
    canvas = this;
    drawGridLine = function(pathString) {
      var path;
      path = canvas.path(pathString);
      return path.attr("stroke-dasharray", "- ");
    };
    drawColumnLine = function(columnLinePosition) {
      return drawGridLine("M" + columnLinePosition + " 0L" + columnLinePosition + " " + le.height);
    };
    drawRowLine = function(rowLinePosition) {
      return drawGridLine("M0 " + rowLinePosition + "L" + le.width + " " + rowLinePosition);
    };
    for (colPos = _ref = le.columnWidth, _ref2 = le.width; (_ref <= _ref2 ? colPos <= _ref2 : colPos >= _ref2); colPos += le.columnWidth) {
      drawColumnLine(colPos);
    }
    for (rowPos = _ref3 = le.rowHeight, _ref4 = le.height; (_ref3 <= _ref4 ? rowPos <= _ref4 : rowPos >= _ref4); rowPos += le.rowHeight) {
      drawRowLine(rowPos);
    }
    square = canvas.rect(le.left, le.right, le.top, le.bottom);
    return square.attr("stroke-width", "5");
  };
  Raphael.fn.plant = function(start, end, name, color) {
    var canvas, centreOfColumn, centreOfRow, footHeight, footWidth, height, left, square, text, top, width;
    canvas = this;
    left = le.getLeftForPlantInColumn(start.column);
    footWidth = end.column - start.column + 1;
    width = ((footWidth - 1) * le.columnWidth) + le.plantWidth;
    top = le.getTopForPlantInRow(start.row);
    footHeight = end.row - start.row + 1;
    height = ((footHeight - 1) * le.rowHeight) + le.plantHeight;
    square = canvas.rect(left, top, width, height, 6);
    square.attr("fill", color);
    square.attr("stroke-width", "3");
    centreOfColumn = left + (width / 2);
    centreOfRow = top + (height / 2);
    text = canvas.text(centreOfColumn, centreOfRow, name);
    return text.attr("font-size", "20");
  };
  Raphael.fn.bed = function(start, end) {
    var canvas, footHeight, footWidth, height, left, square, top, width;
    canvas = this;
    left = le.getLeftForColumn(start.column);
    footWidth = end.column - start.column + 1;
    width = footWidth * le.columnWidth;
    top = le.getTopForRow(start.row);
    footHeight = end.row - start.row + 1;
    height = footHeight * le.rowHeight;
    square = canvas.rect(left, top, width, height);
    square.attr("fill", "#999");
    square.attr("fill-opacity", "0.5");
    return square.attr("stroke-width", "5");
  };
  paper = Raphael("canvas");
  paper.grid();
  paper.bed({
    column: -3,
    row: -1
  }, {
    column: 0,
    row: 2
  });
  paper.bed({
    column: 2,
    row: -1
  }, {
    column: 4,
    row: 1
  });
  paper.plant({
    column: 0,
    row: -1
  }, {
    column: 0,
    row: -1
  }, "Brocolli", "#008000");
  paper.plant({
    column: -1,
    row: -1
  }, {
    column: -1,
    row: -1
  }, "Spring\nOnion", "#00ff7f");
  paper.plant({
    column: -2,
    row: -1
  }, {
    column: -2,
    row: -1
  }, "French\nBean", "#008000");
  paper.plant({
    column: -3,
    row: -1
  }, {
    column: -3,
    row: -1
  }, "French\nBean", "#008000");
  paper.plant({
    column: 0,
    row: 0
  }, {
    column: 0,
    row: 0
  }, "Spring\nOnion", "#00ff7f");
  paper.plant({
    column: -1,
    row: 0
  }, {
    column: -1,
    row: 0
  }, "Chives", "#00ff7f");
  paper.plant({
    column: -2,
    row: 0
  }, {
    column: -2,
    row: 0
  }, "French\nBean", "#008000");
  paper.plant({
    column: -3,
    row: 0
  }, {
    column: -3,
    row: 0
  }, "French\nBean", "#008000");
  paper.plant({
    column: 0,
    row: 1
  }, {
    column: 0,
    row: 1
  }, "Lettuce", "#00ff7f");
  paper.plant({
    column: -1,
    row: 1
  }, {
    column: -1,
    row: 1
  }, "Lettuce", "#00ff7f");
  paper.plant({
    column: -2,
    row: 1
  }, {
    column: -2,
    row: 1
  }, "Lettuce", "#00ff7f");
  paper.plant({
    column: -3,
    row: 1
  }, {
    column: -3,
    row: 1
  }, "Marigold", "#ffff00");
  paper.plant({
    column: 0,
    row: 2
  }, {
    column: 0,
    row: 2
  }, "Lettuce", "#00ff7f");
  paper.plant({
    column: -1,
    row: 2
  }, {
    column: -1,
    row: 2
  }, "Carrot", "#ffa500");
  paper.plant({
    column: -2,
    row: 2
  }, {
    column: -2,
    row: 2
  }, "Carrot", "#ffa500");
  paper.plant({
    column: -3,
    row: 2
  }, {
    column: -3,
    row: 2
  }, "Carrot", "#ffa500");
  paper.plant({
    column: 4,
    row: 1
  }, {
    column: 4,
    row: 1
  }, "Carrot", "#ffa500");
  paper.plant({
    column: 3,
    row: 1
  }, {
    column: 3,
    row: 1
  }, "Carrot", "#ffa500");
  paper.plant({
    column: 2,
    row: 1
  }, {
    column: 2,
    row: 1
  }, "Carrot", "#ffa500");
  paper.plant({
    column: 3,
    row: 0
  }, {
    column: 4,
    row: 0
  }, "Zuchini", "#008045");
  paper.plant({
    column: 2,
    row: 0
  }, {
    column: 2,
    row: 0
  }, "Marigold", "#ffff00");
  paper.plant({
    column: 4,
    row: -1
  }, {
    column: 4,
    row: -1
  }, "Brocolli", "#008000");
  paper.plant({
    column: 3,
    row: -1
  }, {
    column: 3,
    row: -1
  }, "Spring\nOnion", "#00ff7f");
  paper.plant({
    column: 2,
    row: -1
  }, {
    column: 2,
    row: -1
  }, "Marigold", "#ffff00");
  height = $(window).height();
  width = $(window).width();
  window.scrollTo(1500 - (width / 2), 1000 - (height / 2));
  $().ready(function() {
    $(".help a").bind('click', function(event) {
      $("aside.message").animate({
        marginLeft: '25%'
      }, 1000);
      return event.preventDefault();
    });
    $("button.close").bind('click', function(event) {
      return $("aside.message").animate({
        marginLeft: '120%'
      }, 1000);
    });
    return $("#oops").animate({
      marginLeft: '25%'
    }, 1000);
  });
}).call(this);
