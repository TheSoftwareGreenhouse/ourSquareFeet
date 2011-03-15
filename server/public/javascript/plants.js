(function() {
  var Observatory, Plant, Plants, root;
  Plant = typeof exports != "undefined" && exports !== null ? require('./plant').Plant : this.Plant;
  Observatory = typeof exports != "undefined" && exports !== null ? require('./observatory').Observatory : this.Observatory;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  Plants = function() {
    var _observatory, _plants, _split;
    _plants = [];
    _observatory = new Observatory(this);
    _split = function(coord) {
      var plant, result, _i, _len;
      result = {
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
    this.add = function(json) {
      var plant;
      plant = new Plant(json);
      _plants.push(plant);
      return _observatory.publish("new", plant);
    };
    this.existsAtCoord = function(coord) {
      var matches;
      matches = _split(coord);
      return matches.plant !== void 0;
    };
    this.remove = function(coord) {
      var matches;
      matches = _split(coord);
      _plants = matches.others;
      return _observatory.publish("deleted", matches.plant);
    };
    return this;
  };
  root.Plants = Plants;
}).call(this);
