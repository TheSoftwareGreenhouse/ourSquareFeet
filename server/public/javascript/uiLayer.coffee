Observatory = if exports? then require('./observatory').Observatory else this.Observatory

root = exports ? this

UiLayer = (paper) ->
  _paper = paper
  _observatory = new Observatory(@)
  @.squareFeet = []
  @.createSquareFootWidget = (squareFoot) ->
    widget = _paper.squareFoot squareFoot
    widget.subscribe "remove", (squareFootToRemove) ->
      _observatory.publish "squareFoot/delete", squareFootToRemove
    widget.subscribe "plant/new", (squareFootToPlantAt) ->
      _observatory.publish "plant/new", squareFootToPlantAt
    @.squareFeet.push widget
    widget
  @.plants = []
  @.createPlantWidget = (plant) ->
    widget = paper.plant plant
    widget.subscribe "delete", (plantToDelete) ->
      _observatory.publish "plant/delete", plantToDelete
    @.plants.push widget
    widget
  @.removePlantWidget = (plant) ->
    widget = (widget for widget in @.plants when widget.represents(plant))[0]
    @.plants = (plantWidget for plantWidget in @.plants when not plantWidget.represents(plant))
    widget.remove() if widget?
  @

root.UiLayer = UiLayer