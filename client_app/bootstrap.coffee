# Start the application
Backbone.history = new Backbone.History

# CSS signifier
jQuery(($) ->
  # Create root view and put it in the dom
  FDB.rootView = new FDB.ApplicationView()
  FDB.rootView.render()
  $('#application').append(FDB.rootView.el)

  # Create controllers
  new FDB.DashboardController()
  new FDB.LogsController()
  
  # Dispatch primary route and get to work!
  Backbone.history.start()

  # Alert user of flashes
  $('.flash').each (e) ->
    FDB.notify
      message: this.innerHTML
      icon: "ui-icon-#{$(this).attr('class').split(' ')[0]}"
    $(this).remove()
)

