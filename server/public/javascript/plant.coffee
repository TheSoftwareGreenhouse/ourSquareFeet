Rectangle = if exports? then require('./rectangle').Rectangle else this.Rectangle

root = exports ? this

Plant = (json) ->
  _rectangle = new Rectangle(json.start, json.end)
  {
    name: json.name
    color: json.color
    start: _rectangle.start
    end: _rectangle.end
    isOnCoord: (coord) -> _rectangle.containsCoord(coord)
  }

root.Plant = Plant