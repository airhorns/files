# Start the application
Backbone.history = new Backbone.History
jQuery(($) ->
  LDB.rootView = new LDB.ApplicationView()
  LDB.rootView.render()
  $('#application').append(LDB.rootView.el)
  new LDB.DashboardController()
  new LDB.LogsController()
  Backbone.history.start()
)

