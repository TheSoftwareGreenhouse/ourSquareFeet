vows = require 'vows'
assert = require 'assert'
ObservatoryModule = require '../../server/public/javascript/observatory.coffee'
Observatory = ObservatoryModule.Observatory

Host = () ->
  observatory = new Observatory(this)
  this.doSomethingThatCausesAnEvent = (integer) ->
    observatory.publish "theEvent", integer + 1
  this

vows.describe('the Observatory mixin').addBatch({
  'when mixing in an Observatory': {
    topic: () ->
      host = new Host()
    'then the host should have the subscribe/unsubscribe methods': (topic) ->
      assert.isFunction topic.subscribe
      assert.isFunction topic.unsubscribe
    'then the host should have a method that invokes the publish event': (topic) ->
      assert.isFunction topic.doSomethingThatCausesAnEvent
    'when something happens to invoke an event': {
      topic: (topic) ->
        topic.subscribe "theEvent", this.callback
        topic.doSomethingThatCausesAnEvent 1
      'then the subscriber should have run': (err, newInteger) ->
        # vows is assuming that my callback follows the node.js
        # callback pattern i.e. (err, data) which I think is
        # good behaviour, however my code will run in the browser
        # and doesn't follow this pattern. Hence the weird statement
        # below
        assert.equal err, 2
    }
  }
}).export module
