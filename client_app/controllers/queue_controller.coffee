class FDB.QueueController extends Backbone.Controller
  views: {}
  routes:
    '/queue': 'index'
    '/queue/:id': 'show'

  initialize: ->
    @unconfirmed_collection = new FDB.DownloadableCollection()
    @unconfirmed_collection.url = "/api/1/downloadables/unconfirmed"

  index: ->
    unless @views['index']?
      @unconfirmed_collection.fetch({add:true})
      @views['index'] = new (FDB.view('queue/index'))({collection: @unconfirmed_collection})
      FDB.rootView.panel('queue').append @views['index'].el
