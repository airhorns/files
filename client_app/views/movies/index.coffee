FDB.registerView 'movies/index',
class FDB.MoviesIndexView extends FDB.View
  tagName: 'div'
  renderable: -> {}
  initialize: (options) ->
    @collection = options.collection
    # Set up elements
    @thumbs = {}
    this.render()
    this.setUpIsotope()
    
  addThumb: (movie) ->
    @thumbs[movie.id] = new (FDB.view('movies/thumb'))({model:movie})
    @thumbs[movie.id].render()
    @$el.isotope('insert', $(@thumbs[movie.id].el))

  removeThumb: (movie) ->
    $("#movie_thumb_#{movie.id}", @el).remove()
    delete @thumgs[movie.id]

  setUpIsotope: () ->
    # Set up isotope
    @$el = $('.thumb_explorer', @el)
    # Add listeners for adding and removing thumbs
    @collection.bind 'add', (model) =>
      this.addThumb(model)
    @collection.bind 'remove', (model) =>
      this.removeThumb(model)
    @collection.each (model) ->
      this.addThumb(model)

    currentSort = 'added'
    currentDir = false

    @$el.isotope
      getSortData:
        title: (el) => @collection.get(el.data('movie_id')).get('title')
        year: (el) => @collection.get(el.data('movie_id')).get('year')
        rating: (el) => @collection.get(el.data('movie_id')).get('imdb_rating')
        added: (el) => el.data('movie_id') # FIXME
      sortBy: currentSort
      sortAscending: currentDir
      animationEngine: 'css'
      layoutMode: 'fitRows'
    
    # Setup sort key
    $('.sort_by', @el).buttonset().click (e) =>
      newSort = $(e.target).attr('data-sort-by')
      if newSort == currentSort
        currentDir = !currentDir
      else
        currentSort = newSort
        currentDir = false
      @$el.isotope
        sortBy: currentSort
        sortAscending: currentDir

    # Setup search box
    timer = false
    filter = =>
      @$el.isotope
        filter: "[down_title*=#{search.val()}]"

    search = $('input[type="search"]', @el)
    search.keyup (e) =>
      if timer
        clearTimeout(timer)
      timer = setTimeout(filter, 300)
      true

    $('form', @el).submit (e) ->
      e.preventDefault()
      return false
        
