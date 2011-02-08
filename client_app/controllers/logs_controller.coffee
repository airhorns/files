class LDB.LogsController extends Backbone.Controller
  views: {}
  routes:
    '/logs/new': 'new'

  new: ->
    unless @views.new?
      @views.new = new (LDB.view('logs/new'))
      LDB.rootView.panel('new_log').append @views.new.el

    log = new LDB.Log()
    @views.new.model = log
    @views.new.render()
