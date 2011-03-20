(function() {
  var Observatory, SquareFeet, SquareFoot, root;
  Observatory = typeof exports != "undefined" && exports !== null ? require('./observatory').Observatory : this.Observatory;
  SquareFoot = typeof exports != "undefined" && exports !== null ? require('./squarefoot').SquareFoot : this.SquareFoot;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  SquareFeet = function() {
    var _feet, _observatory;
    _feet = [];
    _observatory = new Observatory(this);
    this.add = function(coord) {
      var foot;
      foot = new SquareFoot(coord);
      _feet.push(foot);
      _observatory.publish('new', foot);
      return foot;
    };
    this.exists = function(coordinate) {
      var feet, foot;
      feet = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = _feet.length; _i < _len; _i++) {
          foot = _feet[_i];
          if (foot.coord.matches(coordinate)) {
            _results.push(foot);
          }
        }
        return _results;
      })();
      return feet.length > 0;
    };
    this.remove = function(coordinate) {
      var foot;
      _feet = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = _feet.length; _i < _len; _i++) {
          foot = _feet[_i];
          if (!(foot.coord.matches(coordinate))) {
            _results.push(foot);
          }
        }
        return _results;
      })();
      _observatory.publish('removed', coordinate);
      return true;
    };
    this.updatePlantName = function(plant, newName) {
      return alert(newName);
    };
    return this;
  };
  root.SquareFeet = SquareFeet;
}).call(this);
