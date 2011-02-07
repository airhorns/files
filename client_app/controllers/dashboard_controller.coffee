class LDB.DashboardController extends Backbone.Controller
  routes:
    '':       'index'

  index: ->
    unless LDB.rootView?
      LDB.rootView = new LDB.ApplicationView()
      LDB.rootView.render()
      $('#application').append(LDB.rootView.el)
