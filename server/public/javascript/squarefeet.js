(function() {
  var SquareFeet, root;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  SquareFeet = function() {
    var _feet;
    _feet = [];
    this.add = function(coordinate) {
      var foot;
      foot = {
        c: coordinate.c,
        r: coordinate.r
      };
      _feet.push(foot);
      $(document).trigger('SquareFeet/new', foot);
      return foot;
    };
    this.exists = function(coordinate) {
      var feet, foot;
      feet = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = _feet.length; _i < _len; _i++) {
          foot = _feet[_i];
          if (foot.r === coordinate.r && foot.c === coordinate.c) {
            _results.push(foot);
          }
        }
        return _results;
      })();
      return feet.length > 0;
    };
    return this;
  };
  root.SquareFeet = SquareFeet;
}).call(this);
