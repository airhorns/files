class FDB.Release extends Backbone.Model
  initialize: (options) ->
    @id ||= this.get('_id')
    @downloadable = options.downloadable
    @parent_id = @downloadable.get('_id')
    @url = "/api/1/downloadables/#{@parent_id}/releases/#{@id}"

class FDB.ReleaseCollection extends Backbone.Collection
  model: FDB.Release
  initialize: (models, options) ->
    @parent_id = options.downloadable.get("_id")
    @url = "/api/1/downloadables/#{@parent_id}/releases"
    if options.unconfirmed
      @url += "/unconfirmed"

