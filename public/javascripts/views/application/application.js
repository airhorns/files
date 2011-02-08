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
      this.tabChanged = __bind(this.tabChanged, this);;
      this.tabShown = __bind(this.tabShown, this);;      ApplicationView.__super__.constructor.apply(this, arguments);
    }
    __extends(ApplicationView, LDB.View);
    ApplicationView.prototype.className = "application-tabs";
    ApplicationView.prototype._panels = {};
    ApplicationView.prototype.tabs = [
      {
        name: "Dashboard",
        anchor: "dashboard",
        route: "/dashboard"
      }, {
        name: "New Log",
        anchor: "new_log",
        route: "/logs/new"
      }
    ];
    ApplicationView.prototype.renderable = function() {
      return {
        tabs: this.tabs
      };
    };
    ApplicationView.prototype.render = function() {
      ApplicationView.__super__.render.apply(this, arguments);
      this.ui = $(this.el).bind("tabsshow", this.tabShown).tabs().bind("tabsselect", this.tabChanged);
      return true;
    };
    ApplicationView.prototype.tabShown = function(event, ui) {
      var tab;
      tab = this.tabs[ui.index];
      return this._panels[tab.anchor] = $(ui.panel);
    };
    ApplicationView.prototype.tabChanged = function(event, ui) {
      var tab;
      tab = this.tabs[ui.index];
      return window.location.hash = tab.route;
    };
    ApplicationView.prototype.panel = function(name) {
      var i, tab, _i, _len, _ref;
      if (this._panels[name] != null) {
        return this._panels[name];
      } else {
        i = 0;
        _ref = this.tabs;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tab = _ref[_i];
          if (tab.anchor === name) {
            this.ui.tabs('select', i);
            return this._panels[name];
          }
          i++;
        }
        throw "Don't have any panels anchored by " + name + "!";
      }
    };
    return ApplicationView;
  })());
}).call(this);
