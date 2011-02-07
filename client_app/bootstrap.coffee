# Start the application
Backbone.history = new Backbone.History

jQuery(($) ->
  new LDB.DashboardController()
  Backbone.history.start()
)

