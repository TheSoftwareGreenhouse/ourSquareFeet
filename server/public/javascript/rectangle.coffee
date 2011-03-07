Coord = if exports? then require('./coord').Coord else this.Coord

root = exports ? this

Rectangle = (start, end) ->
  _start = Coord.whatsTopLeft(start,end)
  _end = Coord.whatsBottomRight(start,end)
  {
    start: _start
    end: _end
    containsCoord: (coord) ->
      (_start.c <= coord.c <= _end.c) and (_start.r <= coord.r <= _end.r)
  }

root.Rectangle = Rectangle