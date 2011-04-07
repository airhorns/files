FDB.registerView 'movies/thumb',
class FDB.MoviesThumbView extends FDB.View
  initialize: (movie) ->
    @movie = movie

  renderable: -> @movie

  render: ->
    super()
    @actions = $(".actions", @el)
    $(".nail", @el).hover(this.hoverIn, this.hoverOut)

  hoverIn: (e) =>
    @actions.show()
  hoverOut: (e) =>
    @actions.hide()

