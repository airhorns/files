class LDB.DashboardController extends Backbone.Controller
  views: {}
  routes:
    '':           'index'
    '/dashboard': 'dashboard'

  index: ->
    window.location.hash = '/dashboard'

  dashboard: ->
    unless @views.dashboard?
      @views.dashboard = new (LDB.view('dashboard/dashboard'))
      @views.dashboard.render()
      LDB.rootView.panel('dashboard').append @views.dashboard.el
