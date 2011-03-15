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
    this.plants = [];
    this.createPlantWidget = function(plant) {
      var widget;
      widget = paper.plant(plant);
      widget.subscribe("delete", function(plantToDelete) {
        return _observatory.publish("plant/delete", plantToDelete);
      });
      this.plants.push(widget);
      return widget;
    };
    this.removePlantWidget = function(plant) {
      var plantWidget, widget;
      widget = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.plants;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          widget = _ref[_i];
          if (widget.represents(plant)) {
            _results.push(widget);
          }
        }
        return _results;
      }).call(this))[0];
      this.plants = (function() {
        var _i, _len, _ref, _results;
        _ref = this.plants;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          plantWidget = _ref[_i];
          if (!plantWidget.represents(plant)) {
            _results.push(plantWidget);
          }
        }
        return _results;
      }).call(this);
      if (widget != null) {
        return widget.remove();
      }
    };
    return this;
  };
  root.UiLayer = UiLayer;
}).call(this);
