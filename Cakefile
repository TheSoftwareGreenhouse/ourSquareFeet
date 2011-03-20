{spawn, exec} = require "child_process"
stdout        = process.stdout

runTests = (callback) ->
  exec "vows --spec ./test/unit/*-test.coffee", (err, stdout, stderr) ->
    process.stdout.write stdout
    process.binding("stdio").writeError stderr
    callback err if callback

task 'test', 'run all the tests', (options) ->
  runTests (err) ->
    process.stdout.on "drain", -> process.exit -1 if err