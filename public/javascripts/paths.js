(function() {
  var compiledCounter;
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
    return function() {
      var _base, _ref;
      (_ref = (_base = LDB._compiledHandlebars)[i]) != null ? _ref : _base[i] = Handlebars.compile(templateString);
      return LDB._compiledHandlebars[i](arguments[0], arguments[1]);
    };
  };
  Backbone.View.prototype.renderable = function() {
    if (this.model != null) {
      return this.model.toJSON();
    } else {
      return {};
    }
  };
  Backbone.View.prototype.render = function() {
    $(this.el).html(LDB.ViewRenderers[this.view_path](this.renderable()));
    return this;
  };
}).call(this);
