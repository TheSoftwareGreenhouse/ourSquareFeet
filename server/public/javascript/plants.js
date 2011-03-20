(function() {
  var Observatory, Plant, Plants, root;
  Plant = typeof exports != "undefined" && exports !== null ? require('./plant').Plant : this.Plant;
  Observatory = typeof exports != "undefined" && exports !== null ? require('./observatory').Observatory : this.Observatory;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  Plants = function() {
    var _add, _observatory, _plants, _remove, _split;
    _plants = [];
    _observatory = new Observatory(this);
    _split = function(coord) {
      var plant, result, _i, _len;
      result = {
        plant: null,
        others: []
      };
      for (_i = 0, _len = _plants.length; _i < _len; _i++) {
        plant = _plants[_i];
        if (plant.isOnCoord(coord)) {
          result.plant = plant;
        } else {
          result.others.push(plant);
        }
      }
      return result;
    };
    _add = function(json) {
      var plant;
      plant = new Plant(json);
      _plants.push(plant);
      return plant;
    };
    _remove = function(coord) {
      var matches;
      matches = _split(coord);
      _plants = matches.others;
      return matches.plant;
    };
    this.add = function(json) {
      return _observatory.publish("new", _add(json));
    };
    this.existsAtCoord = function(coord) {
      var matches;
      matches = _split(coord);
      return matches.plant !== null;
    };
    this.remove = function(coord) {
      var plant;
      plant = _remove(coord);
      return _observatory.publish("deleted", plant);
    };
    this.updatePlantName = function(plant, newName) {
      var newJson, newPlant, oldPlant;
      oldPlant = _remove(plant.start);
      newJson = {
        start: {
          c: oldPlant.start.c,
          r: oldPlant.start.r
        },
        end: {
          c: oldPlant.end.c,
          r: oldPlant.end.r
        },
        name: newName,
        color: oldPlant.color
      };
      newPlant = new Plant(newJson);
      _add(newPlant);
      return _observatory.publish("plantChanged", newPlant);
    };
    this.onPlantChanged = function(callback) {
      return _observatory.subscribe("plantChanged", callback);
    };
    this.plants = function() {
      return _plants;
    };
    return this;
  };
  root.Plants = Plants;
}).call(this);
