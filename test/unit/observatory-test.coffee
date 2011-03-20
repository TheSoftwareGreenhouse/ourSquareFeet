vows = require 'vows'
assert = require 'assert'
ObservatoryModule = require '../../server/public/javascript/observatory.coffee'
Observatory = ObservatoryModule.Observatory

vows.describe('the Observatory mixin').addBatch({
  'when creating a new  Observatory': {
    topic: () ->
      {
        mocks: {}
        sut: new Observatory()
        actuals: {}
      }
    'then the observatory should have the subscribe/unsubscribe methods': (topic) ->
      assert.isFunction topic.sut.subscribe
      assert.isFunction topic.sut.unsubscribe
    'then the observatory should have a publish method': (topic) ->
      assert.isFunction topic.sut.publish
    'and a subscription is created': {
      topic: (topic) ->
        topic.actuals.theEventFlag = null
        topic.actuals.subscription = topic.sut.subscribe "theEvent", () ->
          topic.actuals.theEventFlag = true
        topic
      "and the event is published": {
        topic: (topic) ->
          topic.sut.publish "theEvent"
          topic
        'then the subscriber should have run': (topic) ->
          assert.isNotNull topic.actuals.theEventFlag
      }
      "and the subscription is cancelled": {
        topic: (topic) ->
          topic.sut.unsubscribe topic.actuals.subscription
          topic
        "and the event is published": {
          topic: (topic) ->
            topic.actuals.theEventFlag= null
            topic.sut.publish "theEvent"
            topic
          'then the subscriber should not have run': (topic) ->
            assert.isNull topic.actuals.theEventFlag
        }
      }
    }
  }
}).export module
