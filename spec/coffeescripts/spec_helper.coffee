# This is just BS to make testing easier, its not really all that important.
# The testBed stuff makes it easier to use Evergreen's test div for testing anything
# related to rendering or DOM attachment, but if you can avoid using it you should
# so the tests run as fast as possible (and don't touch the dom, just operate in memory)\
# We also monkey patch the javascript testing library to give some better stack traces in
# Chrome, and to log them to the console so that they can be fixed easier and the line 
# numbers become clickable.

require '/javascripts/jquery/jquery.js', '/lib/underscore/underscore.js', '/lib/inflections.js', ->
  testBed = null

  window.$testBed = ->
    testBed ?= $('#test')

  window.testBed = ->
    window.$testBed()[0]

  old = jasmine.ExpectationResult

  jasmine.ExpectationResult = (params) ->
    this.type = 'expect'
    this.matcherName = params.matcherName
    this.passed_ = params.passed
    this.expected = params.expected
    this.actual = params.actual

    this.message = if this.passed_ then 'Passed.' else params.message
    this.trace = if this.passed_ then '' else (params.exception || new Error(params.message)) # Changed line to give better stack traces on Chrome.
    return this

  jasmine.util.inherit jasmine.ExpectationResult, old
  jasmine.Spec.prototype.fail = (e) ->
    expectationResult = new jasmine.ExpectationResult
      passed: false
      message: if e? then jasmine.util.formatException(e) else 'Exception'
      exception: e
    console.log(e.stack) if e? && console?.log?
    this.results_.addResult(expectationResult)

  return

