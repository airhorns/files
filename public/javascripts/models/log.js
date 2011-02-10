(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  LDB.parseTime = function(timeString) {
    var d, time, _ref;
    if (timeString === '') {
      return null;
    }
    d = new Date;
    time = timeString.match(/(\d+)(:(\d\d))?\s*(p?)/i);
    d.setHours(parseInt(time[1], 10) + ((_ref = parseInt(time[1], 10) < 12 && time[4]) != null ? _ref : {
      12: 0
    }));
    d.setMinutes(parseInt(time[3], 10) || 0);
    d.setSeconds(0, 0);
    return d;
  };
  LDB.Log = (function() {
    function Log() {
      Log.__super__.constructor.apply(this, arguments);
    }
    __extends(Log, Backbone.Model);
    Log.prototype.initialize = function() {
      var now;
      now = new Date;
      return this.set({
        startDate: now,
        endDate: new Date(now.getYear(), now.getMonth(), now.getDate(), now.getHours() + 1, now.getMinutes())
      });
    };
    return Log;
  })();
}).call(this);
