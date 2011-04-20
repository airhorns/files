(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.registerView('movies/info', FDB.MoviesInfoView = (function() {
    function MoviesInfoView() {
      this.render = __bind(this.render, this);;      MoviesInfoView.__super__.constructor.apply(this, arguments);
    }
    __extends(MoviesInfoView, FDB.View);
    MoviesInfoView.prototype.initialize = function() {
      return this.model.bind('change', __bind(function() {
        return this.render();
      }, this));
    };
    MoviesInfoView.prototype.render = function() {
      MoviesInfoView.__super__.render.apply(this, arguments);
      if (this.dialog != null) {
        this.destroyDialog();
      }
      this.dialog = $('.dialog', this.el).dialog({
        autoOpen: false,
        height: 600,
        width: 900,
        modal: true,
        beforeClose: function() {
          return window.location = "#/movies";
        }
      });
      return this.show();
    };
    MoviesInfoView.prototype.show = function() {
      return this.dialog.dialog("open");
    };
    MoviesInfoView.prototype.hide = function() {
      return this.dialog.dialog("close");
    };
    MoviesInfoView.prototype.destroyDialog = function() {
      return this.dialog.dialog("destroy");
    };
    return MoviesInfoView;
  })());
}).call(this);
