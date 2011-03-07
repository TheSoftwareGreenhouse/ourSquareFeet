(function() {
  var Coord, root;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  Coord = function(coord) {
    var _coord;
    _coord = coord;
    return {
      r: _coord.r,
      c: _coord.c,
      matches: function(comparison) {
        return (_coord.r === comparison.r) && (_coord.c === comparison.c);
      },
      above: function() {
        return new Coord({
          c: _coord.c,
          r: _coord.r - 1
        });
      },
      below: function() {
        return new Coord({
          c: _coord.c,
          r: _coord.r + 1
        });
      },
      toTheLeft: function() {
        return new Coord({
          c: _coord.c - 1,
          r: _coord.r
        });
      },
      toTheRight: function() {
        return new Coord({
          c: _coord.c + 1,
          r: _coord.r
        });
      }
    };
  };
  Coord.whatsTopLeft = function(firstCoord, secondCoord) {
    return new Coord({
      c: Math.min(firstCoord.c, secondCoord.c),
      r: Math.min(firstCoord.r, secondCoord.r)
    });
  };
  Coord.whatsBottomRight = function(firstCoord, secondCoord) {
    return new Coord({
      c: Math.max(firstCoord.c, secondCoord.c),
      r: Math.max(firstCoord.r, secondCoord.r)
    });
  };
  root.Coord = Coord;
}).call(this);
