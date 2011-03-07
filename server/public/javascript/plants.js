(function() {
  var Observatory, Plant, Plants, root;
  Plant = typeof exports != "undefined" && exports !== null ? require('./plant').Plant : this.Plant;
  Observatory = typeof exports != "undefined" && exports !== null ? require('./observatory').Observatory : this.Observatory;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  Plants = function() {
    var _observatory, _plants;
    _plants = [];
    _observatory = new Observatory(this);
    this.add = function(json) {
      var plant;
      plant = new Plant(json);
      _plants.push(plant);
      return _observatory.publish("new", plant);
    };
    this.existsAtCoord = function(coord) {
      var matches, plant;
      matches = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = _plants.length; _i < _len; _i++) {
          plant = _plants[_i];
          if (plant.isOnCoord(coord)) {
            _results.push(plant);
          }
        }
        return _results;
      })();
      return matches.length > 0;
    };
    return this;
  };
  root.Plants = Plants;
}).call(this);
