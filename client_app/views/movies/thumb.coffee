FDB.registerView 'movies/thumb',
class FDB.MoviesThumbView extends FDB.View
  className: "movie thumb"

  initialize: (movie) ->
    $(@el).attr
      id: "movie_thumb_#{@model.id}"

    $(@el).data
      movie_id: @model.id
  
  renderable: -> @model

  render: ->
    super()
    @actions = $(".actions", @el)
    $(".nail", @el).hover(this.hoverIn, this.hoverOut)
    $(@el).attr("down_title", @model.get('title').toLowerCase())

  hoverIn: (e) =>
    @actions.show()

  hoverOut: (e) =>
    @actions.hide()

