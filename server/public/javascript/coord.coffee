#Observatory = if exports? then require('./observatory').Observatory else this.Observatory

root = exports ? this

Coord = (coord) ->
  _coord = coord
  {
    r: _coord.r
    c: _coord.c
    matches: (comparison) ->
     (_coord.r == comparison.r) and (_coord.c == comparison.c)
    above: () ->      new Coord({c:_coord.c  , r:_coord.r-1})
    below: () ->      new Coord({c:_coord.c  , r:_coord.r+1})
    toTheLeft: () ->  new Coord({c:_coord.c-1, r:_coord.r  })
    toTheRight: () -> new Coord({c:_coord.c+1, r:_coord.r  })
  }

Coord.whatsTopLeft = (firstCoord, secondCoord) ->
  new Coord {
    c:Math.min(firstCoord.c, secondCoord.c)
    r:Math.min(firstCoord.r, secondCoord.r)
  }
Coord.whatsBottomRight = (firstCoord, secondCoord) ->
  new Coord {
    c:Math.max(firstCoord.c, secondCoord.c)
    r:Math.max(firstCoord.r, secondCoord.r)
  }

root.Coord = Coord