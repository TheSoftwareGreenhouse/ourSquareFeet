vows = require 'vows'
assert = require 'assert'
recorderMock = require('../mockjQuery.coffee').recorderMock
PlantsModule = require '../../server/public/javascript/plants.coffee'
PlantModule = require '../../server/public/javascript/plant.coffee'

assert.hasBeenCalled = (actual) ->
  assert.isNotZero actual.__calls.length, "#{actual.name} was not called"

assert.wasCalledWith = (actual, arguments) ->
  matches = (call for call in actual.__calls when (call.arguments[0] is arguments[0] and call.arguments[1] is arguments[1]))
  assert.isNotZero matches.length, "#{actual.name} was not called with #{arguments}"

compareArguments = (arguments, predicates) ->
  for argument in arguments
    for predicate in predicates
      {argument, predicate}

assert.wasCalledWithArguments = (actual, predicates) ->
  matches = (call for call in actual.__calls when (compareArguments(call.arguments, predicates)))
  assert.isNotZero matches.length, "#{actual} was not called with argumenst that matched"

vows.describe('Plants').addBatch({
  'when a new Plants collection is created': {
    topic: () ->
      topic = {
        mocks: {
          plantJson: {start: {c: 3,r: 0}, end: {c: 4,r: 0}, name:"Zuchini", color:"#008045"}
          subscriber: recorderMock "callOnAdd", "callOnDelete", "callOnPlantChanged"
        }
        sut: new PlantsModule.Plants()
      }
      topic.mocks.plant = new PlantModule.Plant(topic.mocks.plantJson)
      topic
    'then the collection has an add method': (topic) ->
      assert.isFunction topic.sut.add
    'then the collection has a existsAtCoord method': (topic) ->
      assert.isFunction topic.sut.existsAtCoord
    'then the collection has a remove method': (topic) ->
      assert.isFunction topic.sut.remove
    'then the collection has an updatePlantName method': (topic) ->
      assert.isFunction topic.sut.updatePlantName
    'then the collection has an onPlantChanged method': (topic) ->
      assert.isFunction topic.sut.onPlantChanged
    'and a plant is added': {
      topic: (topic) ->
        topic.sut = new PlantsModule.Plants()
        topic.sut.subscribe "new", topic.mocks.subscriber.callOnAdd
        topic.sut.add topic.mocks.plantJson
        topic
      'then the plant should exists at both start and end': (topic) ->
        assert.isTrue topic.sut.existsAtCoord({c:3, r:0})
        assert.isTrue topic.sut.existsAtCoord({c:4, r:0})
      'then the plants collection raised the new event': (topic) ->
        assert.hasBeenCalled topic.mocks.subscriber.callOnAdd
      "and the plant's name is updated": {
        topic: (topic) ->
          topic.sut.add topic.mocks.plantJson
          topic.sut.onPlantChanged topic.mocks.subscriber.callOnPlantChanged
          topic.sut.updatePlantName topic.mocks.plant, "Milkwood"
          topic
        'then the plant still exists': (topic) ->
          assert.isTrue topic.sut.existsAtCoord({c:3, r:0})
        'then the plants collection raises the Plant Changed event': (topic) ->
          assert.hasBeenCalled topic.mocks.subscriber.callOnPlantChanged
        'then the plant raised has the correct name': (topic) ->
          assert.equal topic.mocks.subscriber.callOnPlantChanged.__calls[0].arguments[0].name, "Milkwood"
      }
    }
  }
}).addBatch({
  'when the Plants collection is populated': {
    topic: () ->
      topic = {
        mocks: {
          subscriber: recorderMock "callOnDelete"
        }
        sut: new PlantsModule.Plants()
      }
      topic.sut.add {start: {c: 0,r: 0}, end: {c: 0,r: 0}, name:"Corn", color:"#008045"}
      topic.sut.add {start: {c: 1,r: 0}, end: {c: 1,r: 0}, name:"Peas", color:"#008045"}
      topic.sut.add {start: {c: 2,r: 0}, end: {c: 2,r: 0}, name:"Bananas", color:"#008045"}
      topic
    'and the plant is removed': {
      topic: (topic) ->
        topic.sut.subscribe "deleted", topic.mocks.subscriber.callOnDelete
        topic.sut.remove {c:0, r:0}
        topic
      'then the plant should not exist at the start or end': (topic) ->
        assert.isFalse topic.sut.existsAtCoord({c:0, r:0})
      'then the plants collection raises a deleted event': (topic) ->
        assert.hasBeenCalled topic.mocks.subscriber.callOnDelete
      'then the correct plant is deleted': (topic) ->
        assert.equal topic.mocks.subscriber.callOnDelete.__calls[0].arguments[0].name, "Corn"
        #assert.wasCalledWith topic.mocks.subscriber.callOnDelete, [topic.mocks.plant]
    }
  }
}).export module
