(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.LogsController = (function() {
    function LogsController() {
      LogsController.__super__.constructor.apply(this, arguments);
    }
    __extends(LogsController, Backbone.Controller);
    LogsController.prototype.views = {};
    LogsController.prototype.routes = {
      '/logs/new': 'new'
    };
    LogsController.prototype["new"] = function() {
      var log;
      if (this.views["new"] == null) {
        this.views["new"] = new (FDB.view('logs/new'));
        FDB.rootView.panel('new_log').append(this.views["new"].el);
      }
      log = new FDB.Log();
      this.views["new"].model = log;
      return this.views["new"].render();
    };
    return LogsController;
  })();
}).call(this);
