(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  FDB.MoviesController = (function() {
    __extends(MoviesController, Backbone.Controller);
    function MoviesController() {
      MoviesController.__super__.constructor.apply(this, arguments);
    }
    MoviesController.prototype.views = {};
    MoviesController.prototype.routes = {
      '/movies': 'index',
      '/movies/:id': 'show'
    };
    MoviesController.prototype.initialize = function() {
      return this.collection = new FDB.MovieCollection();
    };
    MoviesController.prototype.index = function() {
      var spinner;
      if (this.views['index'] == null) {
        this.views['index'] = new (FDB.view('movies/index'))({
          collection: this.collection
        });
        FDB.rootView.panel('movies').append(this.views['index'].el);
        spinner = $("<img src=\"/images/spinner.gif\">");
        $(this.views['index'].el).append(spinner);
        return this.collection.fetch({
          add: true,
          success: __bind(function() {
            return spinner.remove();
          }, this)
        });
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
