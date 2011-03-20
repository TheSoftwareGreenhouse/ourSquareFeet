Observatory = if exports? then require('./observatory').Observatory else this.Observatory

root = exports ? this

Model = (plants) ->
  _observatory = new Observatory()
  _plants = plants
  _plants.onPlantChanged (plant) ->
    _observatory.publish 'plant/changed', plant
  _plants.subscribe "new", (plant) ->
    _observatory.publish 'plant/new', plant
  _plants.subscribe "deleted", (plant) ->
    _observatory.publish 'plant/deleted', plant
  @.updatePlantName = (plant, newName) ->
    _plants.updatePlantName plant, newName
  @.onPlantChanged = (callback) ->
    _observatory.subscribe 'plant/changed', callback
  @.onPlantNew = (callback) ->
    _observatory.subscribe 'plant/new', callback
  @.onPlantDeleted = (callback) ->
    _observatory.subscribe 'plant/deleted', callback
  @

root.Model = Model