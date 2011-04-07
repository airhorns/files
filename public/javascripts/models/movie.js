(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.Movie = (function() {
    function Movie() {
      Movie.__super__.constructor.apply(this, arguments);
    }
    __extends(Movie, Backbone.Model);
    Movie.prototype.initialize = function() {
      return this.url = "/api/1/movies/" + this.id;
    };
    return Movie;
  })();
  FDB.MovieCollection = (function() {
    function MovieCollection() {
      MovieCollection.__super__.constructor.apply(this, arguments);
    }
    __extends(MovieCollection, Backbone.Collection);
    MovieCollection.prototype.model = FDB.Movie;
    MovieCollection.prototype.url = "/api/1/movies";
    return MovieCollection;
  })();
}).call(this);
