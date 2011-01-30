npm           = require "npm"
{spawn, exec} = require "child_process"
stdout        = process.stdout

TEST_DIR = "./test"
UNIT_TEST_DIR = "#{TEST_DIR}/unit"

option '-t', '--tests [FILE]', 'test files to run'
option '-s', '--spec', 'show spec for tests'

runTests = (testsToRun, callback) ->
  exec "vows #{testsToRun}", (err, stdout, stderr) ->
    process.stdout.write stdout
    process.binding("stdio").writeError stderr
    callback err if callback

task 'test', 'run the tests', (options) ->
  specFlag = if options.spec then "--spec " else ""
  fileName = specFlag + (options.tests or "#{UNIT_TEST_DIR}/*-test.coffee")
  runTests fileName, (err) ->
    process.stdout.on "drain", -> process.exit -1 if err

task 'start', 'starts the My Garden Plan server', (options) ->
  exec "./scripts/startServer.sh", (err, stdout, stderr) ->
    process.stdout.write stdout
    process.binding('stdio').writeError stderr
    process.stdout.on "drain", -> process.exit -1 if err

task 'stop', 'stops the My Garden Plan server', (options) ->
  exec "./scripts/stopServer.sh", (err, stdout, stderr) ->
    process.stdout.write stdout
    process.binding('stdio').writeError stderr
    process.stdout.on "drain", -> process.exit -1 if err


