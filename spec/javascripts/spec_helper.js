(function() {
  require('/javascripts/jquery/jquery.js', '/lib/underscore/underscore.js', '/lib/inflections.js', function() {
    var old, testBed;
    testBed = null;
    window.$testBed = function() {
      return testBed != null ? testBed : testBed = $('#test');
    };
    window.testBed = function() {
      return window.$testBed()[0];
    };
    old = jasmine.ExpectationResult;
    jasmine.ExpectationResult = function(params) {
      this.type = 'expect';
      this.matcherName = params.matcherName;
      this.passed_ = params.passed;
      this.expected = params.expected;
      this.actual = params.actual;
      this.message = this.passed_ ? 'Passed.' : params.message;
      this.trace = this.passed_ ? '' : params.exception || new Error(params.message);
      return this;
    };
    jasmine.util.inherit(jasmine.ExpectationResult, old);
    jasmine.Spec.prototype.fail = function(e) {
      var expectationResult;
      expectationResult = new jasmine.ExpectationResult({
        passed: false,
        message: e != null ? jasmine.util.formatException(e) : 'Exception',
        exception: e
      });
      if ((e != null) && ((typeof console != "undefined" && console !== null ? console.log : void 0) != null)) {
        console.log(e.stack);
      }
      return this.results_.addResult(expectationResult);
    };
    return;
  });
}).call(this);
