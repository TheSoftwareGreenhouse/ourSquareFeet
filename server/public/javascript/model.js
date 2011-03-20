(function() {
  var Model, Observatory, root;
  Observatory = typeof exports != "undefined" && exports !== null ? require('./observatory').Observatory : this.Observatory;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  Model = function(plants) {
    var _observatory, _plants;
    _observatory = new Observatory();
    _plants = plants;
    _plants.onPlantChanged(function(plant) {
      return _observatory.publish('plant/changed', plant);
    });
    _plants.subscribe("new", function(plant) {
      return _observatory.publish('plant/new', plant);
    });
    _plants.subscribe("deleted", function(plant) {
      return _observatory.publish('plant/deleted', plant);
    });
    this.updatePlantName = function(plant, newName) {
      return _plants.updatePlantName(plant, newName);
    };
    this.onPlantChanged = function(callback) {
      return _observatory.subscribe('plant/changed', callback);
    };
    this.onPlantNew = function(callback) {
      return _observatory.subscribe('plant/new', callback);
    };
    this.onPlantDeleted = function(callback) {
      return _observatory.subscribe('plant/deleted', callback);
    };
    return this;
  };
  root.Model = Model;
}).call(this);
