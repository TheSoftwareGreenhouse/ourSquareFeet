vows = require 'vows'
assert = require 'assert'
jQuery = require('./mockjQuery.coffee').jQuery
recorderMock = require('./mockjQuery.coffee').recorderMock

assert.hasBeenCalled = (actual) ->
  assert.isNotZero actual.__calls.length, "#{actual.name} was not called"

assert.wasCalledWith = (actual, arguments) ->
  matches = (call for call in actual.__calls when (call.arguments[0] is arguments[0] and call.arguments[1] is arguments[1]))
  assert.isNotZero matches.length, "#{actual.name} was not called with #{arguments}"

executeSubscribers = (method, argumentNumber) ->
  for call in method.__calls
    call.arguments[argumentNumber].call null

exports.assert = assert
exports.vows = vows
exports.jQuery = jQuery
exports.recorderMock = recorderMock
exports.executeSubscribers = executeSubscribers