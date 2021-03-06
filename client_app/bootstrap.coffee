# Start the application
Backbone.history = new Backbone.History

# CSS signifier
jQuery ($) ->
  # Register partial views
  for name, fn of FDB.ViewRenderers
    if name.charAt(0) == "_" || name.indexOf("/_") != -1
      Handlebars.registerPartial(name, fn)

  # Alert user of flashes
  $('.flash').each (e) ->
    FDB.notify
      message: this.innerHTML
      icon: "ui-icon-#{$(this).attr('class').split(' ')[0]}"
    $(this).remove()

  if $('body').hasClass('application')
    # Create root view and put it in the dom
    FDB.rootView = new FDB.ApplicationView()
    FDB.rootView.render()
    $('#application').append(FDB.rootView.el)

    # Create controllers
    new FDB.DashboardController()
    new FDB.FilesController()
    new FDB.MoviesController()
    new FDB.QueueController()
    new FDB.SecretEditController()
    
    # Dispatch primary route and get to work!
    Backbone.history.start()

