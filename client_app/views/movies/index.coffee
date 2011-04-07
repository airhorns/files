FDB.registerView 'movies/index',
class FDB.MoviesIndexView extends FDB.View
  tagName: 'div'
  className: 'thumb_explorer'

  initialize: (collection) ->
    @collection = collection
    @thumbs = {}
    @collection.each (model) ->
      this.addThumb(model)

    @collection.bind 'add', (model) =>
      this.addThumb(model)
    @collection.bind 'remove', (model) =>
      this.addThumb(model)
    
  addThumb: (movie) ->
    @thumbs[movie.id] = new (FDB.view('movies/thumb'))(movie)
    @thumbs[movie.id].render()
    $(@el).append(@thumbs[movie.id].el)

  removeThumb: (movie) ->
    $("#movie_thumb_#{movie.id}", @el).remove()
    delete @thumgs[movie.id]

  render: -> true
