Coord = if exports? then require('./coord').Coord else this.Coord

root = exports ? this

SquareFoot = (coord) ->
  _coord = new Coord(coord)
  {
    coord: _coord
    neighbours: {
      top:    _coord.above()
      bottom: _coord.below()
      left:   _coord.toTheLeft()
      right:  _coord.toTheRight()
    }
    containsPlant: () ->
      return false;
  }

root.SquareFoot = SquareFoot