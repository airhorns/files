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
      '/movies/id': 'show'
    };
    MoviesController.prototype.index = function() {
      var c;
      if (this.views['index'] == null) {
        c = new FDB.MovieCollection();
        this.views['index'] = new (FDB.view('movies/index'))(c);
        c.fetch({
          add: true
        });
        return FDB.rootView.panel('movies').append(this.views['index'].el);
      }
    };
    MoviesController.prototype.show = function() {};
    return MoviesController;
  })();
}).call(this);
