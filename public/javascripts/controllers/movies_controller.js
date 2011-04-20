(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.MoviesController = (function() {
    function MoviesController() {
      MoviesController.__super__.constructor.apply(this, arguments);
    }
    __extends(MoviesController, Backbone.Controller);
    MoviesController.prototype.views = {};
    MoviesController.prototype.routes = {
      '/movies': 'index',
      '/movies/:id': 'show'
    };
    MoviesController.prototype.initialize = function() {
      return this.collection = new FDB.MovieCollection();
    };
    MoviesController.prototype.index = function() {
      if (this.views['index'] == null) {
        this.collection.fetch({
          add: true
        });
        this.views['index'] = new (FDB.view('movies/index'))({
          collection: this.collection
        });
        return FDB.rootView.panel('movies').append(this.views['index'].el);
      }
    };
    MoviesController.prototype.show = function(id) {
      var movie;
      if (!(movie = this.collection.get(id))) {
        movie = new FDB.Movie({
          id: id
        });
        movie.fetch();
      }
      if (!this.views["movie_" + id]) {
        this.views["movie_" + id] = new (FDB.view('movies/info'))({
          model: movie
        });
        this.views["movie_" + id].render();
        FDB.rootView.panel('movies').append(this.views["movie_" + id].el);
      }
      return this.views["movie_" + id].show();
    };
    return MoviesController;
  })();
}).call(this);
