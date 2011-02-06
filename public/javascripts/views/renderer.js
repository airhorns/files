(function() {
  LDB.renderTemplate = function(templateString) {
    var i, _ref;
    (_ref = LDB._compiledHandlebars) != null ? _ref : LDB._compiledHandlebars = {};
    i = LDB._compiledHandlebars.length;
    return function() {
      var _base, _ref;
      (_ref = (_base = LDB._compiledHandlebars)[i]) != null ? _ref : _base[i] = Handlebars.compile(templateString);
      return LDB._compiledHandlebars[i](arguments[0], arguments[1]);
    };
  };
  Backbone.View.prototype.render = function() {
    $(this.el).html(LDB.ViewRenderers[this.view_path](this.model.toJSON()));
    return this;
  };
}).call(this);
