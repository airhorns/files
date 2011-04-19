FDB.registerView 'movies/info',
class FDB.MoviesInfoView extends FDB.View
  initialize: ->
    # Rerender once we have the movie's stuff, if we don't have it already
    unless @model.get('title')
      @model.bind 'change', this.render

  render: =>
    super
    $('.dialog', @el).dialog
      height: 600
      width: 900
      modal: true

