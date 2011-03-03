root = exports ? this

SquareFeet = () ->
  _feet =[]
  this.add = (coordinate) ->
    foot = {c:coordinate.c, r:coordinate.r}
    _feet.push foot
    $(document).trigger 'SquareFeet/new', foot
    foot
  this.exists = (coordinate) ->
    feet = (foot for foot in _feet when (foot.r == coordinate.r and foot.c == coordinate.c))
    feet.length > 0
  this


root.SquareFeet = SquareFeet