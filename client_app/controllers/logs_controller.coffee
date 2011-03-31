class FDB.LogsController extends Backbone.Controller
  views: {}
  routes:
    '/logs/new': 'new'

  new: ->
    unless @views.new?
      @views.new = new (FDB.view('logs/new'))
      FDB.rootView.panel('new_log').append @views.new.el

    log = new FDB.Log()
    @views.new.model = log
    @views.new.render()
