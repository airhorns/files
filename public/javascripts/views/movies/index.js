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
    MoviesIndexView.prototype.renderable = function() {
      return {};
    };
    MoviesIndexView.prototype.initialize = function(options) {
      this.thumbs = {};
      this.render();
      return this.setUpIsotope();
    };
    MoviesIndexView.prototype.addThumb = function(movie) {
      this.thumbs[movie.id] = new (FDB.view('movies/thumb'))({
        model: movie
      });
      this.thumbs[movie.id].render();
      return this.$el.isotope('insert', $(this.thumbs[movie.id].el));
    };
    MoviesIndexView.prototype.removeThumb = function(movie) {
      $("#movie_thumb_" + movie.id, this.el).remove();
      return delete this.thumgs[movie.id];
    };
    MoviesIndexView.prototype.setUpIsotope = function() {
      var currentDir, currentSort, filter, search, timer;
      this.$el = $('.thumb_explorer', this.el);
      this.collection.bind('add', __bind(function(model) {
        return this.addThumb(model);
      }, this));
      this.collection.bind('remove', __bind(function(model) {
        return this.removeThumb(model);
      }, this));
      this.collection.each(function(model) {
        return this.addThumb(model);
      });
      currentSort = 'added';
      currentDir = false;
      this.$el.isotope({
        getSortData: {
          title: __bind(function(el) {
            return this.collection.get(el.data('movie_id')).get('title');
          }, this),
          year: __bind(function(el) {
            return this.collection.get(el.data('movie_id')).get('year');
          }, this),
          rating: __bind(function(el) {
            return this.collection.get(el.data('movie_id')).get('imdb_rating');
          }, this),
          added: __bind(function(el) {
            return el.data('movie_id');
          }, this)
        },
        sortBy: currentSort,
        sortAscending: currentDir,
        animationEngine: 'css',
        layoutMode: 'fitRows'
      });
      $('.sort_by', this.el).buttonset().click(__bind(function(e) {
        var newSort;
        newSort = $(e.target).attr('data-sort-by');
        if (newSort === currentSort) {
          currentDir = !currentDir;
        } else {
          currentSort = newSort;
          currentDir = false;
        }
        return this.$el.isotope({
          sortBy: currentSort,
          sortAscending: currentDir
        });
      }, this));
      timer = false;
      filter = __bind(function() {
        return this.$el.isotope({
          filter: "[down_title*=" + (search.val()) + "]"
        });
      }, this);
      search = $('input[type="search"]', this.el);
      search.keyup(__bind(function(e) {
        if (timer) {
          clearTimeout(timer);
        }
        timer = setTimeout(filter, 300);
        return true;
      }, this));
      return $('form', this.el).submit(function(e) {
        e.preventDefault();
        return false;
      });
    };
    return MoviesIndexView;
  })());
}).call(this);
