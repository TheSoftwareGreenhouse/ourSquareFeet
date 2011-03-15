Plant = if exports? then require('./plant').Plant else this.Plant
Observatory = if exports? then require('./observatory').Observatory else this.Observatory

root = exports ? this

Plants= () ->
  _plants = []
  _observatory = new Observatory(this)
  _split = (coord) ->
    result = {
      others: []
    }
    for plant in _plants
      if plant.isOnCoord(coord) then result.plant = plant else result.others.push plant
    result
  this.add = (json) ->
    plant = new Plant(json)
    _plants.push plant
    _observatory.publish "new", plant
  this.existsAtCoord = (coord) ->
    matches = _split(coord)
    matches.plant != undefined
  this.remove = (coord) ->
    matches = _split(coord)
    _plants = matches.others
    _observatory.publish "deleted", matches.plant
  this

root.Plants = Plants