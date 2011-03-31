class FDB.DashboardController extends Backbone.Controller
  views: {}
  routes:
    '':           'index'
    '/dashboard': 'dashboard'

  index: ->
    window.location.hash = '/dashboard'

  dashboard: ->
    unless @views.dashboard?
      @views.dashboard = new (FDB.view('dashboard/dashboard'))
      @views.dashboard.render()
      FDB.rootView.panel('dashboard').append @views.dashboard.el
