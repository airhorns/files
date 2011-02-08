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
    DashboardController.prototype.views = {};
    DashboardController.prototype.routes = {
      '': 'index',
      '/dashboard': 'dashboard'
    };
    DashboardController.prototype.index = function() {
      return window.location.hash = '/dashboard';
    };
    DashboardController.prototype.dashboard = function() {
      if (this.views.dashboard == null) {
        this.views.dashboard = new (LDB.view('dashboard/dashboard'));
        this.views.dashboard.render();
        return LDB.rootView.panel('dashboard').append(this.views.dashboard.el);
      }
    };
    return DashboardController;
  })();
}).call(this);
