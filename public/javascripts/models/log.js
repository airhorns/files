(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.Log = (function() {
    function Log() {
      Log.__super__.constructor.apply(this, arguments);
    }
    __extends(Log, Backbone.Model);
    Log.prototype.initialize = function() {
      var end, now;
      now = new Date;
      now.setMinutes(now.getMinutes() - now.getMinutes() % 30);
      end = new Date;
      end.setTime(now.valueOf() + 60 * 1000 * 60);
      return this.set({
        start_date: now,
        end_date: end
      });
    };
    return Log;
  })();
}).call(this);
