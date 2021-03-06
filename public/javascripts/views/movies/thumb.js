(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.registerView('movies/thumb', FDB.MoviesThumbView = (function() {
    function MoviesThumbView() {
      this.hoverOut = __bind(this.hoverOut, this);;
      this.hoverIn = __bind(this.hoverIn, this);;      MoviesThumbView.__super__.constructor.apply(this, arguments);
    }
    __extends(MoviesThumbView, FDB.View);
    MoviesThumbView.prototype.className = "movie thumb";
    MoviesThumbView.prototype.initialize = function(movie) {
      $(this.el).attr({
        id: "movie_thumb_" + this.model.id
      });
      return $(this.el).data({
        movie_id: this.model.id
      });
    };
    MoviesThumbView.prototype.render = function() {
      MoviesThumbView.__super__.render.call(this);
      this.actions = $(".actions", this.el);
      $(".nail", this.el).hover(this.hoverIn, this.hoverOut);
      return $(this.el).attr("down_title", this.model.get('title').toLowerCase());
    };
    MoviesThumbView.prototype.hoverIn = function(e) {
      return this.actions.show();
    };
    MoviesThumbView.prototype.hoverOut = function(e) {
      return this.actions.hide();
    };
    return MoviesThumbView;
  })());
}).call(this);
