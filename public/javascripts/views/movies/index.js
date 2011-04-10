(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  FDB.registerView('movies/index', FDB.MoviesIndexView = (function() {
    function MoviesIndexView() {
      MoviesIndexView.__super__.constructor.apply(this, arguments);
    }
    __extends(MoviesIndexView, FDB.View);
    MoviesIndexView.prototype.tagName = 'div';
    MoviesIndexView.prototype.className = 'thumb_explorer';
    MoviesIndexView.prototype.initialize = function(collection) {
      this.collection = collection;
      this.thumbs = {};
      this.$el = $(this.el);
      this.$el.isotope({
        getSortData: {
          title: __bind(function(el) {
            return this.collection.at(el.data('movie_id')).get('title');
          }, this),
          year: __bind(function(el) {
            return this.collection.at(el.data('movie_id')).get('year');
          }, this),
          rating: __bind(function(el) {
            return this.collection.at(el.data('movie_id')).get('rating');
          }, this),
          added: __bind(function(el) {
            return el.data('movie_id');
          }, this)
        },
        sortBy: 'added',
        sortAscending: false
      });
      this.collection.each(function(model) {
        return this.addThumb(model);
      });
      this.collection.bind('add', __bind(function(model) {
        return this.addThumb(model);
      }, this));
      return this.collection.bind('remove', __bind(function(model) {
        return this.removeThumb(model);
      }, this));
    };
    MoviesIndexView.prototype.addThumb = function(movie) {
      this.thumbs[movie.id] = new (FDB.view('movies/thumb'))(movie);
      this.thumbs[movie.id].render();
      return this.$el.isotope('insert', this.thumbs[movie.id].el);
    };
    MoviesIndexView.prototype.removeThumb = function(movie) {
      $("#movie_thumb_" + movie.id, this.el).remove();
      return delete this.thumgs[movie.id];
    };
    MoviesIndexView.prototype.render = function() {
      return true;
    };
    return MoviesIndexView;
  })());
}).call(this);
