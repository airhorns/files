(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  LDB.Log = (function() {
    function Log() {
      Log.__super__.constructor.apply(this, arguments);
    }
    __extends(Log, Backbone.Model);
    Log.prototype.initialize = function() {
      var now;
      now = new Date;
      now.setMinutes(now.getMinutes() - now.getMinutes() % 30);
      return this.set({
        start_date: now,
        end_date: new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours() + 1, now.getMinutes())
      });
    };
    return Log;
  })();
}).call(this);
