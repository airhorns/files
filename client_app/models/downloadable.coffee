class FDB.Downloadable extends Backbone.Model
  initialize: ->
    @id ||= this.get('_id')
    @url = "/api/1/downloadable/#{@id}"
    extras = {downloadable: this}
    @releases = new FDB.ReleaseCollection(_(this.get('releases')).map((x) -> _.extend(x, extras)), extras)
    @unconfirmed_releases = new FDB.ReleaseCollection(@releases.select((x) -> x.get('confirmed') == false), extras)

class FDB.DownloadableCollection extends Backbone.Collection
  model: FDB.Downloadable
  url: "/api/1/downloadables"

