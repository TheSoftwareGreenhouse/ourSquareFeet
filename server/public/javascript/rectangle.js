(function() {
  var Coord, Rectangle, root;
  Coord = typeof exports != "undefined" && exports !== null ? require('./coord').Coord : this.Coord;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  Rectangle = function(start, end) {
    var _end, _start;
    _start = Coord.whatsTopLeft(start, end);
    _end = Coord.whatsBottomRight(start, end);
    return {
      start: _start,
      end: _end,
      containsCoord: function(coord) {
        var _ref, _ref2;
        return ((_start.c <= (_ref = coord.c) && _ref <= _end.c)) && ((_start.r <= (_ref2 = coord.r) && _ref2 <= _end.r));
      }
    };
  };
  root.Rectangle = Rectangle;
}).call(this);
