FDB.registerView 'movies/index',
class FDB.MoviesIndexView extends FDB.View
  tagName: 'div'
  className: 'thumb_explorer'

  initialize: (collection) ->
    @collection = collection
    @thumbs = {}

    @$el = $(@el)
    @$el.isotope
      getSortData:
        title: (el) => @collection.at(el.data('movie_id')).get('title')
        year: (el) => @collection.at(el.data('movie_id')).get('year')
        rating: (el) => @collection.at(el.data('movie_id')).get('rating')
        added: (el) => el.data('movie_id') # FIXME
      sortBy: 'added'
      sortAscending: false

    @collection.each (model) ->
      this.addThumb(model)

    @collection.bind 'add', (model) =>
      this.addThumb(model)
    @collection.bind 'remove', (model) =>
      this.removeThumb(model)

    
  addThumb: (movie) ->
    @thumbs[movie.id] = new (FDB.view('movies/thumb'))(movie)
    @thumbs[movie.id].render()
    @$el.isotope('insert', @thumbs[movie.id].el)

  removeThumb: (movie) ->
    $("#movie_thumb_#{movie.id}", @el).remove()
    delete @thumgs[movie.id]

  render: -> true
