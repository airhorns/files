FDB.registerView 'movies/thumb',
class FDB.MoviesThumbView extends FDB.View
  className: "movie thumb"

  initialize: (movie) ->
    @movie = movie
    $(@el).attr
      id: "movie_thumb_#{@movie.id}"
    $(@el).data
      movie_id: @movie.id
  
  renderable: -> @movie

  render: ->
    super()
    @actions = $(".actions", @el)
    $(".nail", @el).hover(this.hoverIn, this.hoverOut)

  hoverIn: (e) =>
    @actions.show()
  hoverOut: (e) =>
    @actions.hide()

