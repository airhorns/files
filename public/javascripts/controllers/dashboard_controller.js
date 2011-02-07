(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  LDB.DashboardController = (function() {
    function DashboardController() {
      DashboardController.__super__.constructor.apply(this, arguments);
    }
    __extends(DashboardController, Backbone.Controller);
    DashboardController.prototype.routes = {
      '': 'index'
    };
    DashboardController.prototype.index = function() {
      if (LDB.rootView == null) {
        LDB.rootView = new LDB.ApplicationView();
        LDB.rootView.render();
        return $('#application').append(LDB.rootView.el);
      }
    };
    return DashboardController;
  })();
}).call(this);
