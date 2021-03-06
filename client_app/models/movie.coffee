class FDB.Movie extends Backbone.Model
  initialize: ->
    @id ||= this.get('_id')
    @url = "/api/1/movies/#{@id}"

class FDB.MovieCollection extends Backbone.Collection
  model: FDB.Movie
  url: "/api/1/movies"
