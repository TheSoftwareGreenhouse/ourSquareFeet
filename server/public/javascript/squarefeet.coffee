Observatory = if exports? then require('./observatory').Observatory else this.Observatory
SquareFoot = if exports? then require('./squarefoot').SquareFoot else this.SquareFoot

root = exports ? this

SquareFeet = () ->
  _feet =[]
  _observatory = new Observatory(this)
  this.add = (coord) ->
    foot = new SquareFoot(coord)
    _feet.push foot
    _observatory.publish 'new', foot
    foot
  this.exists = (coordinate) ->
    feet = (foot for foot in _feet when (foot.coord.matches(coordinate)))
    feet.length > 0
  this.remove = (coordinate) ->
    _feet = (foot for foot in _feet when not (foot.coord.matches(coordinate)))
    _observatory.publish 'removed', coordinate
    true
  this.updatePlantName = (plant, newName) ->
    alert newName
  this


root.SquareFeet = SquareFeet