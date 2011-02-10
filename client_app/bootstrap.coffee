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
  $('.flash').each (e) ->
    LDB.notify
      message: this.innerHTML
      icon: "ui-icon-#{$(this).attr('class').split(' ')[0]}"
    $(this).remove()
)

