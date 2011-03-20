(function() {
  var Observatory, PlantWidget, Rectangle, root;
  Observatory = typeof exports != "undefined" && exports !== null ? require('./../observatory').Observatory : this.Observatory;
  Rectangle = typeof exports != "undefined" && exports !== null ? require('./../rectangle').Rectangle : this.Rectangle;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  PlantWidget = function(layoutEngine, plant) {
    var centerOfColumn, centerOfRow, color, columnWidth, end, footHeight, footWidth, height, le, left, mouseStillInPlant, name, rectangle, rowHeight, start, top, widget, width, _children, _mouseOut, _mouseOver, _observatory, _primitives;
    le = layoutEngine;
    start = plant.start;
    end = plant.end;
    rectangle = new Rectangle(start, end);
    name = plant.name;
    color = plant.color;
    columnWidth = le.columnWidth;
    rowHeight = le.rowHeight;
    left = le.getLeftForPlantInColumn(start.c);
    footWidth = end.c - start.c + 1;
    width = ((footWidth - 1) * columnWidth) + le.plantWidth;
    top = le.getTopForPlantInRow(start.r);
    footHeight = end.r - start.r + 1;
    height = ((footHeight - 1) * rowHeight) + le.plantHeight;
    centerOfColumn = left + (width / 2);
    centerOfRow = top + (height / 2);
    _primitives = {};
    _children = {};
    widget = {
      top: top,
      left: left,
      width: width,
      height: height,
      centerRow: centerOfRow,
      centerColumn: centerOfColumn,
      color: color,
      name: name,
      children: _children,
      isAt: function(coord) {
        return rectangle.containsCoord(coord);
      },
      primitives: _primitives,
      addRect: function(rect) {
        rect.hover(_mouseOver, _mouseOut);
        return _primitives.rect = rect;
      },
      addText: function(text) {
        text.hover(_mouseOver, _mouseOut);
        return _primitives.text = text;
      },
      applyAttributes: function(attributes) {
        var attribute, primitive, _results;
        _results = [];
        for (primitive in attributes) {
          attribute = attributes[primitive];
          _results.push(_primitives[primitive].attr(attribute));
        }
        return _results;
      },
      plant: plant
    };
    mouseStillInPlant = function(event) {
      var inHorizontally, inVertically, _ref, _ref2;
      if (event != null) {
        event = $.event.fix(event);
        inHorizontally = (left < (_ref = event.pageX) && _ref < (left + width));
        inVertically = (top < (_ref2 = event.pageY) && _ref2 < (top + height));
        return inHorizontally && inVertically;
      }
    };
    _mouseOver = function() {
      if (_children.closeButton != null) {
        return _children.closeButton.show();
      }
    };
    _mouseOut = function(event) {
      if ((_children.closeButton != null) && !mouseStillInPlant(event)) {
        return _children.closeButton.hide();
      }
    };
    _observatory = new Observatory(widget);
    widget.addCloseButtonWidget = function(closeButtonWidget) {
      _children.closeButton = closeButtonWidget;
      _children.closeButton.subscribe("click", function() {
        return _observatory.publish("delete", plant);
      });
      return _children.closeButton.hide();
    };
    widget.onEditName = function(callback) {
      _primitives.text.onChange(function(newText) {
        return _observatory.publish("editName", newText);
      });
      return _observatory.subscribe("editName", callback);
    };
    widget.remove = function() {
      var key, primitive, _results;
      if (_children.closeButton != null) {
        _children.closeButton.remove();
      }
      _results = [];
      for (key in _primitives) {
        primitive = _primitives[key];
        _results.push(primitive.remove());
      }
      return _results;
    };
    return widget;
  };
  root.PlantWidget = PlantWidget;
}).call(this);
