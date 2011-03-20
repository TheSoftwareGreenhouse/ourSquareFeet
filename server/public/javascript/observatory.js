(function() {
  var Observatory, root;
  var __slice = Array.prototype.slice;
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  Observatory = function(host) {
    var cache, subscribe, unsubscribe;
    cache = {};
    subscribe = function(topic, callback) {
      if (!cache[topic]) {
        cache[topic] = [];
      }
      cache[topic].push(callback);
      return [topic, callback];
    };
    unsubscribe = function(handle) {
      var subscriber, t;
      t = handle[0];
      if (cache[t] != null) {
        return cache[t] = (function() {
          var _i, _len, _ref, _results;
          _ref = cache[t];
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            subscriber = _ref[_i];
            if (subscriber !== handle[1]) {
              _results.push(subscriber);
            }
          }
          return _results;
        })();
      }
    };
    if (host != null) {
      host.subscribe = subscribe;
      host.unsubscribe = unsubscribe;
    }
    return {
      publish: function() {
        var args, subscription, topic, _i, _len, _ref, _results;
        topic = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        if (cache[topic] != null) {
          _ref = cache[topic];
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            subscription = _ref[_i];
            _results.push(subscription.apply(root, args || []));
          }
          return _results;
        }
      },
      subscribe: subscribe,
      unsubscribe: unsubscribe
    };
  };
  root.Observatory = Observatory;
}).call(this);
