Plant = if exports? then require('./plant').Plant else this.Plant
Observatory = if exports? then require('./observatory').Observatory else this.Observatory

root = exports ? this

Plants= () ->
  _plants = []
  _observatory = new Observatory(this)
  this.add = (json) ->
    plant = new Plant(json)
    _plants.push plant
    _observatory.publish "new", plant
  this.existsAtCoord = (coord) ->
    matches = (plant for plant in _plants when plant.isOnCoord(coord))
    matches.length > 0
  this

root.Plants = Plants