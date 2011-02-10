(function() {
  var compiledCounter;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __slice = Array.prototype.slice;
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
      var cb, renderable, _i, _len, _ref;
      renderable = this.renderable();
      $(this.el).html(this.getBars()(renderable));
      if (renderable._afterCallbacks != null) {
        _ref = renderable._afterCallbacks;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cb = _ref[_i];
          cb();
        }
      }
      return this;
    };
    View.prototype.getBars = function() {
      return LDB.ViewRenderers[this.view_path];
    };
    return View;
  })();
  Handlebars.registerHelper('after', function() {
    var args, fn, self;
    fn = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    self = this;
    this._afterCallbacks || (this._afterCallbacks = []);
    return this._afterCallbacks.push(function() {
      return fn.apply(self, args);
    });
  });
  LDB.notify = function(textOrOptions) {
    var options;
    options = {
      timeout: 4,
      icon: 'ui-icon-info'
    };
    if (_.isString(textOrOptions)) {
      options.message = textOrOptions;
    } else {
      options = _.extend({}, options, textOrOptions);
    }
    return $.achtung(options);
  };
}).call(this);
