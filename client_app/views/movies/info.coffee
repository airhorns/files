FDB.registerView 'movies/info',
class FDB.MoviesInfoView extends FDB.View
  initialize: ->
    # Rerender once we have the movie's stuff, if we don't have it already
    @model.bind 'change', =>
      this.render()

  render: =>
    super
    # Delete any old dialog, and reinstantiate with new data
    this.destroyDialog() if @dialog?
    @dialog = $('.dialog', @el).dialog
      autoOpen: false
      height: 600
      width: 900
      modal: true
      beforeClose: -> window.location = "#/movies"
    this.show()

  show: -> @dialog.dialog("open")
  hide: -> @dialog.dialog("close")
  destroyDialog: -> @dialog.dialog("destroy")
