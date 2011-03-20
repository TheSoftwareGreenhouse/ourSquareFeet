vows = require 'vows'
assert = require 'assert'
recorderMock = require('../mockjQuery.coffee').recorderMock
ModelModule = require '../../server/public/javascript/model.coffee'

# REMINDER: move this to common module
assert.wasCalledWith = (actual, arguments) ->
  matches = (call for call in actual.__calls when (call.arguments[0] is arguments[0] and call.arguments[1] is arguments[1]))
  assert.isNotZero matches.length, "#{actual.name} was not called with #{arguments}"

executeSubscribersOf = (method, argumentNumber, argumentsToPass = []) ->
  for call in method.__calls
    call.arguments[argumentNumber].apply null, argumentsToPass


vows.describe('the Model').addBatch({
  'when a new Model is created': {
    topic: () ->
      topic = {
        mocks: {
          subscriber: recorderMock "callOnPlantChanged", "callOnPlantNew", "callOnPlantDeleted"
          plant:  "mock plant"
          plants: recorderMock "updatePlantName", "onPlantChanged", "subscribe"
        }
        sut: {}
        actuals: {}
      }
      topic.sut = new ModelModule.Model(topic.mocks.plants)
      topic
    'then the Model has an updatePlantName method': (topic) ->
      assert.isFunction topic.sut.updatePlantName
    'then the Model has an onPlantChanged method': (topic) ->
      assert.isFunction topic.sut.onPlantChanged
    'then the Model has an onPlantNew method': (topic) ->
      assert.isFunction topic.sut.onPlantNew
    'then the Model has an onPlantDeleted method': (topic) ->
      assert.isFunction topic.sut.onPlantDeleted
    'and the Model is asked to update the name of a plant': {
      topic: (topic) ->
        topic.sut.updatePlantName "Lemongrass"
        topic
      "then the plants has been asked to update the plant's name": (topic) ->
        assert.wasCalledWith topic.mocks.plants.updatePlantName, ["Lemongrass"]
    }
    'and there is a subscriber to the OnPlantChange event': {
      topic: (topic) ->
        topic.sut.onPlantChanged topic.mocks.subscriber.callOnPlantChanged
        topic
      'and the Plants collection has a changed Plant': {
        topic: (topic) ->
          executeSubscribersOf topic.mocks.plants.onPlantChanged, 0, [topic.mocks.plant]
          topic
        'then the Model has raised an onPlantChanged event': (topic) ->
          assert.wasCalledWith topic.mocks.subscriber.callOnPlantChanged, [topic.mocks.plant]
      }
    }
    'and there is a subscriber to the OnPlantNew event': {
      topic: (topic) ->
        topic.sut.onPlantNew topic.mocks.subscriber.callOnPlantNew
        topic
      'and the Plants collection has a new Plant': {
        topic: (topic) ->
          executeSubscribersOf topic.mocks.plants.subscribe, 1, [topic.mocks.plant]
          topic
        'then the Model has raised an onPlantNew event': (topic) ->
          assert.wasCalledWith topic.mocks.subscriber.callOnPlantNew, [topic.mocks.plant]
      }
    }
    'and there is a subscriber to the OnPlantDeleted event': {
      topic: (topic) ->
        topic.sut.onPlantDeleted topic.mocks.subscriber.callOnPlantDeleted
        topic
      'and the Plants collection has a new Plant': {
        topic: (topic) ->
          executeSubscribersOf topic.mocks.plants.subscribe, 1, [topic.mocks.plant]
          topic
        'then the Model has raised an onPlantNew event': (topic) ->
          assert.wasCalledWith topic.mocks.subscriber.callOnPlantDeleted, [topic.mocks.plant]
      }
    }
  }
}).export module
