(function() {
  var Coord, SquareFoot, root;
  Coord = typeof exports != "undefined" && exports !== null ? require('./coord').Coord : this.Coord;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  SquareFoot = function(coord) {
    var _coord;
    _coord = new Coord(coord);
    return {
      coord: _coord,
      neighbours: {
        top: _coord.above(),
        bottom: _coord.below(),
        left: _coord.toTheLeft(),
        right: _coord.toTheRight()
      },
      containsPlant: function() {
        return false;
      }
    };
  };
  root.SquareFoot = SquareFoot;
}).call(this);
