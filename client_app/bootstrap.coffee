# Start the application
Backbone.history = new Backbone.History

# CSS signifier
jQuery(($) ->
  # Create root view and put it in the dom
  LDB.rootView = new LDB.ApplicationView()
  LDB.rootView.render()
  $('#application').append(LDB.rootView.el)

  # Create controllers
  new LDB.DashboardController()
  new LDB.LogsController()
  
  # Dispatch primary route and get to work!
  Backbone.history.start()

  # Alert user of flashes
  LDB.notify("Signed in successfully.")
  
  $('.flash').each (e) ->
    LDB.notify(this.innerHTML)
    $(this).remove()
)

