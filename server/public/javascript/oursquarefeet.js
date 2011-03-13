(function() {
  var config, grid, height, le, paper, persistance, plant, plants, sf, squareFoot, ui, updateBordersOf, width, _i, _j, _len, _len2, _ref, _ref2;
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
  sf = new SquareFeet();
  plants = new Plants();
  Raphael.fn.straightLine = function(left, top, width, height) {
    var canvas;
    canvas = this;
    return canvas.path("M" + left + " " + top + "L" + (left + width) + " " + (top + height));
  };
  Raphael.fn.closeButton = function(left, top, width, height) {
    var button, canvas, click, cross, factor, formatPath, graphic, key, mouseOff, mouseOn, observatory, path, rect, slashDown, slashUp, _i, _len, _ref, _ref2, _ref3;
    canvas = this;
    factor = 0.25;
    cross = {
      left: left + Math.floor(factor * width),
      top: top + Math.floor(factor * height),
      width: Math.floor((1 - (1.5 * factor)) * width),
      height: Math.floor((1 - (1.5 * factor)) * height)
    };
    rect = canvas.rect(left, top, width, height, 3);
    slashUp = canvas.straightLine(cross.left, cross.top + cross.height, cross.width, -cross.height);
    slashDown = canvas.straightLine(cross.left, cross.top, cross.width, cross.height);
    rect.attr({
      "fill": "#f00",
      "fill-opacity": ".2"
    });
    formatPath = function(path) {
      var attributes;
      attributes = {
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke": "#222"
      };
      return path.attr(attributes);
    };
    _ref = [slashUp, slashDown, rect];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      path = _ref[_i];
      formatPath(path);
    }
    button = {
      graphics: {
        rect: rect,
        slashUp: slashUp,
        slashDown: slashDown
      },
      remove: function() {
        slashUp.remove();
        slashDown.remove();
        return rect.remove();
      },
      hide: function() {
        slashUp.hide();
        slashDown.hide();
        return rect.hide();
      },
      show: function() {
        slashUp.show();
        slashDown.show();
        rect.attr({
          opacity: 0
        });
        rect.show();
        return rect.animate({
          opacity: 1
        }, 400);
      }
    };
    observatory = new Observatory(button);
    click = function(event) {
      return observatory.publish("click", "closing");
    };
    _ref2 = button.graphics;
    for (key in _ref2) {
      graphic = _ref2[key];
      graphic.click(click);
    }
    mouseOn = function(event) {
      rect.animate({
        "fill-opacity": ".8"
      }, 200);
      return observatory.publish("mouseOn");
    };
    mouseOff = function(event) {
      rect.animate({
        "fill-opacity": ".2"
      }, 200);
      return observatory.publish("mouseOff");
    };
    _ref3 = button.graphics;
    for (key in _ref3) {
      graphic = _ref3[key];
      graphic.hover(mouseOn, mouseOff);
    }
    return button;
  };
  Raphael.fn.squareFoot = function(squareFoot) {
    var borders, canvas, closeButtonDim, drawBorder, drawBottomBorder, drawLeftBorder, drawRightBorder, drawTopBorder, height, left, mouseOff, mouseOn, mouseStillInSquare, observatory, square, top, width;
    canvas = this;
    left = le.getLeftForColumn(squareFoot.coord.c);
    width = le.columnWidth;
    top = le.getTopForRow(squareFoot.coord.r);
    height = le.rowHeight;
    drawBorder = function(from, to) {
      var path;
      path = canvas.path("M" + from.x + " " + from.y + "L" + to.x + " " + to.y);
      path.attr("stroke-width", "5");
      path.attr("stroke-linecap", "round");
      path.hide();
      return path;
    };
    drawTopBorder = function() {
      return drawBorder({
        x: left,
        y: top
      }, {
        x: left + width,
        y: top
      });
    };
    drawBottomBorder = function() {
      return drawBorder({
        x: left,
        y: top + height
      }, {
        x: left + width,
        y: top + height
      });
    };
    drawLeftBorder = function() {
      return drawBorder({
        x: left,
        y: top
      }, {
        x: left,
        y: top + height
      });
    };
    drawRightBorder = function() {
      return drawBorder({
        x: left + width,
        y: top
      }, {
        x: left + width,
        y: top + height
      });
    };
    square = canvas.rect(left, top, width, height);
    square.attr("fill", "#999");
    square.attr("fill-opacity", "0.5");
    square.attr("stroke-opacity", "0");
    borders = {
      top: drawTopBorder(),
      bottom: drawBottomBorder(),
      left: drawLeftBorder(),
      right: drawRightBorder()
    };
    square.borders = borders;
    closeButtonDim = {
      left: left + Math.floor(0.8 * width),
      top: top + Math.floor(0.05 * height),
      width: Math.floor(0.15 * width),
      height: Math.floor(0.15 * height)
    };
    square.closeButton = canvas.closeButton(closeButtonDim.left, closeButtonDim.top, closeButtonDim.width, closeButtonDim.height);
    observatory = new Observatory(square);
    square.closeButton.subscribe("click", function(text) {
      return observatory.publish("remove", squareFoot);
    });
    square.updateBorders = function() {
      if (sf.exists(squareFoot.neighbours.top)) {
        borders.top.hide();
      } else {
        borders.top.show();
      }
      if (sf.exists(squareFoot.neighbours.bottom)) {
        borders.bottom.hide();
      } else {
        borders.bottom.show();
      }
      if (sf.exists(squareFoot.neighbours.left)) {
        borders.left.hide();
      } else {
        borders.left.show();
      }
      if (sf.exists(squareFoot.neighbours.right)) {
        return borders.right.hide();
      } else {
        return borders.right.show();
      }
    };
    square.updateBorders();
    square.coord = squareFoot.coord;
    square.destroy = function() {
      var key, value;
      square.closeButton.remove();
      for (key in borders) {
        value = borders[key];
        value.remove();
      }
      return square.remove();
    };
    mouseStillInSquare = function(event) {
      var inHorizontally, inVertically, _ref, _ref2;
      if (event != null) {
        event = $.event.fix(event);
        inHorizontally = (left < (_ref = event.pageX) && _ref < (left + width));
        inVertically = (top < (_ref2 = event.pageY) && _ref2 < (top + height));
        return inHorizontally && inVertically;
      }
    };
    mouseOn = function() {
      if (!plants.existsAtCoord(squareFoot.coord)) {
        return square.closeButton.show();
      }
    };
    mouseOff = function(event) {
      if (!mouseStillInSquare(event)) {
        return square.closeButton.hide();
      }
    };
    square.hover(mouseOn, mouseOff);
    square.closeButton.hide();
    mouseOn;
    return square;
  };
  Raphael.fn.grid = function() {
    var canvas, colPos, drawColumnLine, drawGridLine, drawRowLine, rowPos, square, _i, _j, _len, _len2, _ref, _ref2;
    canvas = this;
    square = canvas.rect(le.left, le.top, le.width, le.height);
    square.attr("stroke-width", "5");
    square.attr("fill", "#fdfdfd");
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
    return square;
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
  persistance = {};
  persistance.squareFeet = [
    {
      c: -3,
      r: -1
    }, {
      c: -2,
      r: -1
    }, {
      c: -1,
      r: -1
    }, {
      c: 0,
      r: -1
    }, {
      c: -3,
      r: 0
    }, {
      c: -2,
      r: 0
    }, {
      c: -1,
      r: 0
    }, {
      c: 0,
      r: 0
    }, {
      c: -3,
      r: 1
    }, {
      c: -2,
      r: 1
    }, {
      c: -1,
      r: 1
    }, {
      c: 0,
      r: 1
    }, {
      c: -3,
      r: 2
    }, {
      c: -2,
      r: 2
    }, {
      c: -1,
      r: 2
    }, {
      c: 0,
      r: 2
    }, {
      c: 2,
      r: -1
    }, {
      c: 3,
      r: -1
    }, {
      c: 4,
      r: -1
    }, {
      c: 2,
      r: 0
    }, {
      c: 3,
      r: 0
    }, {
      c: 4,
      r: 0
    }, {
      c: 2,
      r: 1
    }, {
      c: 3,
      r: 1
    }, {
      c: 4,
      r: 1
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
  ui = {
    squareFeet: []
  };
  paper = Raphael("canvas");
  grid = paper.grid();
  $(grid.node).bind("click", function(event) {
    var c, r, squareFoot;
    c = le.pixelsToColumn(event.pageX);
    r = le.pixelsToRow(event.pageY);
    return squareFoot = sf.add({
      c: c,
      r: r
    });
  });
  window.TheObservatory = new Observatory();
  plants.subscribe("new", function(plant) {
    return paper.plant(plant);
  });
  sf.subscribe("new", function(squareFoot) {
    var uiSquareFoot;
    uiSquareFoot = paper.squareFoot(squareFoot);
    uiSquareFoot.subscribe("remove", function(sfToRemove) {
      return sf.remove(sfToRemove.coord);
    });
    ui.squareFeet.push(uiSquareFoot);
    return updateBordersOf(squareFoot.coord);
  });
  sf.subscribe("removed", function(coord) {
    var foot, uiSquareFoot;
    uiSquareFoot = ((function() {
      var _i, _len, _ref, _results;
      _ref = ui.squareFeet;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        foot = _ref[_i];
        if (foot.coord.matches(coord)) {
          _results.push(foot);
        }
      }
      return _results;
    })())[0];
    ui.squareFeet = (function() {
      var _i, _len, _ref, _results;
      _ref = ui.squareFeet;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        foot = _ref[_i];
        if (!(foot.coord.matches(coord))) {
          _results.push(foot);
        }
      }
      return _results;
    })();
    uiSquareFoot.destroy();
    return updateBordersOf(coord);
  });
  updateBordersOf = function(coord) {
    var getUiSquareFoot, neighbour, neighbours, position, squareFootUi, _results;
    getUiSquareFoot = function(coord) {
      var foot, matches;
      matches = (function() {
        var _i, _len, _ref, _results;
        _ref = ui.squareFeet;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          foot = _ref[_i];
          if (coord.matches(foot.coord)) {
            _results.push(foot);
          }
        }
        return _results;
      })();
      if (matches.length === 1) {
        return matches[0];
      } else {
        return null;
      }
    };
    neighbours = {
      top: coord.above(),
      bottom: coord.below(),
      left: coord.toTheLeft(),
      right: coord.toTheRight()
    };
    _results = [];
    for (position in neighbours) {
      neighbour = neighbours[position];
      squareFootUi = getUiSquareFoot(neighbour);
      _results.push(squareFootUi !== null ? squareFootUi.updateBorders() : void 0);
    }
    return _results;
  };
  _ref = persistance.squareFeet;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    squareFoot = _ref[_i];
    sf.add(squareFoot);
  }
  _ref2 = persistance.plants;
  for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
    plant = _ref2[_j];
    plants.add(plant);
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
