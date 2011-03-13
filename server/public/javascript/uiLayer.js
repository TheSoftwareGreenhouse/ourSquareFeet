(function() {
  var Observatory, UiLayer, root;
  Observatory = typeof exports != "undefined" && exports !== null ? require('./observatory').Observatory : this.Observatory;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  UiLayer = function(paper) {
    var _observatory, _paper;
    _paper = paper;
    _observatory = new Observatory(this);
    this.squareFeet = [];
    this.createSquareFootWidget = function(squareFoot) {
      var widget;
      widget = _paper.squareFoot(squareFoot);
      widget.subscribe("remove", function(squareFootToRemove) {
        return _observatory.publish("squareFoot/delete", squareFootToRemove);
      });
      widget.subscribe("plant/new", function(squareFootToPlantAt) {
        return _observatory.publish("plant/new", squareFootToPlantAt);
      });
      this.squareFeet.push(widget);
      return widget;
    };
    this.createPlantWidget = function(plant) {
      return paper.plant(plant);
    };
    return this;
  };
  root.UiLayer = UiLayer;
}).call(this);
