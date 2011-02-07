(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  LDB.registerView("application/application", LDB.ApplicationView = (function() {
    function ApplicationView() {
      this.tabChanged = __bind(this.tabChanged, this);;      ApplicationView.__super__.constructor.apply(this, arguments);
    }
    __extends(ApplicationView, Backbone.View);
    ApplicationView.prototype.className = "application-tabs";
    ApplicationView.prototype.tabs = [
      {
        name: "Dashboard",
        anchor: "dashboard",
        view: 'dashboard/dashboard'
      }, {
        name: "New Log",
        anchor: "new",
        view: 'logs/new'
      }
    ];
    ApplicationView.prototype.renderable = function() {
      return {
        tabs: this.tabs
      };
    };
    ApplicationView.prototype.render = function() {
      ApplicationView.__super__.render.apply(this, arguments);
      return $(this.el).tabs().bind("tabsselect", this.tabChanged).tabs('select', 1).tabs('select', 0);
    };
    ApplicationView.prototype.tabChanged = function(event, ui) {
      var tab;
      tab = this.tabs[ui.index];
      if (tab.rendered == null) {
        tab.rendered = (new (LDB.view(tab.view))).render();
        $(ui.panel).append(tab.rendered.el);
      }
      return true;
    };
    return ApplicationView;
  })());
}).call(this);
