(function() {
  var Plant, Rectangle, root;
  Rectangle = typeof exports != "undefined" && exports !== null ? require('./rectangle').Rectangle : this.Rectangle;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  Plant = function(json) {
    var _rectangle;
    _rectangle = new Rectangle(json.start, json.end);
    return {
      name: json.name,
      color: json.color,
      start: _rectangle.start,
      end: _rectangle.end,
      isOnCoord: function(coord) {
        return _rectangle.containsCoord(coord);
      }
    };
  };
  root.Plant = Plant;
}).call(this);
