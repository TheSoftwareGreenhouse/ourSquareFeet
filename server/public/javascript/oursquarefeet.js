(function() {
  var bed, config, height, le, paper, persistance, plant, width, _i, _j, _len, _len2, _ref, _ref2;
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
    var canvas, colPos, drawColumnLine, drawGridLine, drawRowLine, rowPos, square, _i, _j, _len, _len2, _ref, _ref2;
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
    _ref = le.columnPositions;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      colPos = _ref[_i];
      drawColumnLine(colPos);
    }
    _ref2 = le.rowPositions;
    for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
      rowPos = _ref2[_j];
      drawRowLine(rowPos);
    }
    square = canvas.rect(le.left, le.right, le.top, le.bottom);
    return square.attr("stroke-width", "5");
  };
  Raphael.fn.plant = function(plant) {
    var canvas, centreOfColumn, centreOfRow, color, end, footHeight, footWidth, height, left, name, square, start, text, top, width;
    canvas = this;
    start = plant.start;
    end = plant.end;
    name = plant.name;
    color = plant.color;
    left = le.getLeftForPlantInColumn(start.c);
    footWidth = end.c - start.c + 1;
    width = ((footWidth - 1) * le.columnWidth) + le.plantWidth;
    top = le.getTopForPlantInRow(start.r);
    footHeight = end.r - start.r + 1;
    height = ((footHeight - 1) * le.rowHeight) + le.plantHeight;
    square = canvas.rect(left, top, width, height, 6);
    square.attr("fill", color);
    square.attr("stroke-width", "3");
    centreOfColumn = left + (width / 2);
    centreOfRow = top + (height / 2);
    text = canvas.text(centreOfColumn, centreOfRow, name);
    return text.attr("font-size", "20");
  };
  Raphael.fn.bed = function(bed) {
    var canvas, end, footHeight, footWidth, height, left, square, start, top, width;
    canvas = this;
    start = bed.start;
    end = bed.end;
    left = le.getLeftForColumn(start.c);
    footWidth = end.c - start.c + 1;
    width = footWidth * le.columnWidth;
    top = le.getTopForRow(start.r);
    footHeight = end.r - start.r + 1;
    height = footHeight * le.rowHeight;
    square = canvas.rect(left, top, width, height);
    square.attr("fill", "#999");
    square.attr("fill-opacity", "0.5");
    return square.attr("stroke-width", "5");
  };
  paper = Raphael("canvas");
  paper.grid();
  persistance = {};
  persistance.beds = [
    {
      start: {
        c: -3,
        r: -1
      },
      end: {
        c: 0,
        r: 2
      }
    }, {
      start: {
        c: 2,
        r: -1
      },
      end: {
        c: 4,
        r: 1
      }
    }
  ];
  persistance.plants = [
    {
      start: {
        c: 0,
        r: -1
      },
      end: {
        c: 0,
        r: -1
      },
      name: "Brocolli",
      color: "#008000"
    }, {
      start: {
        c: -1,
        r: -1
      },
      end: {
        c: -1,
        r: -1
      },
      name: "Spring\nOnion",
      color: "#00ff7f"
    }, {
      start: {
        c: -2,
        r: -1
      },
      end: {
        c: -2,
        r: -1
      },
      name: "French\nBean",
      color: "#008000"
    }, {
      start: {
        c: -3,
        r: -1
      },
      end: {
        c: -3,
        r: -1
      },
      name: "French\nBean",
      color: "#008000"
    }, {
      start: {
        c: 0,
        r: 0
      },
      end: {
        c: 0,
        r: 0
      },
      name: "Spring\nOnion",
      color: "#00ff7f"
    }, {
      start: {
        c: -1,
        r: 0
      },
      end: {
        c: -1,
        r: 0
      },
      name: "Chives",
      color: "#00ff7f"
    }, {
      start: {
        c: -2,
        r: 0
      },
      end: {
        c: -2,
        r: 0
      },
      name: "French\nBean",
      color: "#008000"
    }, {
      start: {
        c: -3,
        r: 0
      },
      end: {
        c: -3,
        r: 0
      },
      name: "French\nBean",
      color: "#008000"
    }, {
      start: {
        c: 0,
        r: 1
      },
      end: {
        c: 0,
        r: 1
      },
      name: "Lettuce",
      color: "#00ff7f"
    }, {
      start: {
        c: -1,
        r: 1
      },
      end: {
        c: -1,
        r: 1
      },
      name: "Lettuce",
      color: "#00ff7f"
    }, {
      start: {
        c: -2,
        r: 1
      },
      end: {
        c: -2,
        r: 1
      },
      name: "Lettuce",
      color: "#00ff7f"
    }, {
      start: {
        c: -3,
        r: 1
      },
      end: {
        c: -3,
        r: 1
      },
      name: "Marigold",
      color: "#ffff00"
    }, {
      start: {
        c: 0,
        r: 2
      },
      end: {
        c: 0,
        r: 2
      },
      name: "Lettuce",
      color: "#00ff7f"
    }, {
      start: {
        c: -1,
        r: 2
      },
      end: {
        c: -1,
        r: 2
      },
      name: "Carrot",
      color: "#ffa500"
    }, {
      start: {
        c: -2,
        r: 2
      },
      end: {
        c: -2,
        r: 2
      },
      name: "Carrot",
      color: "#ffa500"
    }, {
      start: {
        c: -3,
        r: 2
      },
      end: {
        c: -3,
        r: 2
      },
      name: "Carrot",
      color: "#ffa500"
    }, {
      start: {
        c: 4,
        r: 1
      },
      end: {
        c: 4,
        r: 1
      },
      name: "Carrot",
      color: "#ffa500"
    }, {
      start: {
        c: 3,
        r: 1
      },
      end: {
        c: 3,
        r: 1
      },
      name: "Carrot",
      color: "#ffa500"
    }, {
      start: {
        c: 2,
        r: 1
      },
      end: {
        c: 2,
        r: 1
      },
      name: "Carrot",
      color: "#ffa500"
    }, {
      start: {
        c: 3,
        r: 0
      },
      end: {
        c: 4,
        r: 0
      },
      name: "Zuchini",
      color: "#008045"
    }, {
      start: {
        c: 2,
        r: 0
      },
      end: {
        c: 2,
        r: 0
      },
      name: "Marigold",
      color: "#ffff00"
    }, {
      start: {
        c: 4,
        r: -1
      },
      end: {
        c: 4,
        r: -1
      },
      name: "Brocolli",
      color: "#008000"
    }, {
      start: {
        c: 3,
        r: -1
      },
      end: {
        c: 3,
        r: -1
      },
      name: "Spring\nOnion",
      color: "#00ff7f"
    }, {
      start: {
        c: 2,
        r: -1
      },
      end: {
        c: 2,
        r: -1
      },
      name: "Marigold",
      color: "#ffff00"
    }
  ];
  _ref = persistance.beds;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    bed = _ref[_i];
    paper.bed(bed);
  }
  _ref2 = persistance.plants;
  for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
    plant = _ref2[_j];
    paper.plant(plant);
  }
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
