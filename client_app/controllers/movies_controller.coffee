class FDB.MoviesController extends Backbone.Controller
  views: {}
  routes:
    '/movies': 'index'
    '/movies/:id': 'show'

  initialize: ->
    @collection = new FDB.MovieCollection()

  index: ->
    unless @views['index']?
      @views['index'] = new (FDB.view('movies/index'))({collection: @collection})
      FDB.rootView.panel('movies').append @views['index'].el
      spinner = $ "<img src=\"/images/spinner.gif\">"
      $(@views['index'].el).append spinner
      @collection.fetch 
        add: true
        success: => spinner.remove()

  show: (id) ->
    # Find (possibly fetch) movie
    unless movie = @collection.get(id)
      movie = new FDB.Movie
        id: id
      movie.fetch()
    
    # Render view
    unless @views["movie_#{id}"]
      @views["movie_#{id}"] = new (FDB.view('movies/info'))({model: movie})
      @views["movie_#{id}"].render()
      FDB.rootView.panel('movies').append @views["movie_#{id}"].el

    # Show view
    @views["movie_#{id}"].show()
