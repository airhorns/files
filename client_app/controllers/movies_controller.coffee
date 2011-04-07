class FDB.MoviesController extends Backbone.Controller
  views: {}
  routes:
    '/movies': 'index'
    '/movies/id': 'show'

  index: ->
    unless @views['index']?
      c = new FDB.MovieCollection()
      @views['index'] = new (FDB.view('movies/index'))(c)
      c.fetch({add:true})
      FDB.rootView.panel('movies').append @views['index'].el

  show: ->
