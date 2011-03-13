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
  @.createPlantWidget = (plant) ->
    paper.plant plant
  @

root.UiLayer = UiLayer