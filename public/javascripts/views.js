(function() {
  var compiledCounter;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  window.LDB = {
    Views: {},
    ViewRenderers: {},
    _compiledHandlebars: {}
  };
  LDB.registerView = function(name, klass) {
    klass.prototype.view_path = name;
    return LDB.Views[name] = klass;
  };
  LDB.view = function(name) {
    return LDB.Views[name];
  };
  compiledCounter = -1;
  LDB.renderTemplate = function(templateString) {
    var i;
    i = compiledCounter++;
    return function(data, fallback) {
      var _base, _ref;
      (_ref = (_base = LDB._compiledHandlebars)[i]) != null ? _ref : _base[i] = Handlebars.compile(templateString);
      return LDB._compiledHandlebars[i](data, fallback);
    };
  };
  LDB.View = (function() {
    function View() {
      View.__super__.constructor.apply(this, arguments);
    }
    __extends(View, Backbone.View);
    View.prototype.renderable = function() {
      if (this.model != null) {
        return this.model.toJSON();
      } else {
        return {};
      }
    };
    View.prototype.render = function() {
      $(this.el).html(LDB.ViewRenderers[this.view_path](this.renderable()));
      return this;
    };
    return View;
  })();
}).call(this);
