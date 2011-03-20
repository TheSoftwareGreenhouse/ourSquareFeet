Plant = if exports? then require('./plant').Plant else this.Plant
Observatory = if exports? then require('./observatory').Observatory else this.Observatory

root = exports ? this

Plants= () ->
  _plants = []
  _observatory = new Observatory(this)
  _split = (coord) ->
    result = {
      plant: null
      others: []
    }
    for plant in _plants
      if plant.isOnCoord(coord) then result.plant = plant else result.others.push plant
    result
  _add = (json) ->
    plant = new Plant(json)
    _plants.push plant
    plant
  _remove = (coord) ->
    matches = _split(coord)
    _plants = matches.others
    matches.plant
  this.add = (json) ->
    _observatory.publish "new", _add(json)
  this.existsAtCoord = (coord) ->
    matches = _split(coord)
    matches.plant isnt null
  this.remove = (coord) ->
    plant = _remove coord
    _observatory.publish "deleted", plant
  this.updatePlantName = (plant, newName) ->
    oldPlant = _remove plant.start
    newJson = {
      start: {c: oldPlant.start.c, r: oldPlant.start.r}
      end:   {c: oldPlant.end.c,   r: oldPlant.end.r  }
      name:  newName,
      color: oldPlant.color
    }
    newPlant = new Plant(newJson)
    _add newPlant
    _observatory.publish "plantChanged", newPlant
  this.onPlantChanged = (callback) ->
    _observatory.subscribe "plantChanged", callback
  this.plants = () ->
    _plants
  this


root.Plants = Plants