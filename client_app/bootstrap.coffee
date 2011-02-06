window.LDB =
  Views: {}
  ViewRenderers: {}

# The LDB.ViewRenderers object is populated by the Jammit asset packager. 
# Views are pulled from client_app/views and put into the object using their path as keys,
# so you can expect to see things like LDB.ViewRenderers['logs/index'] to pull out the view.
# The function below compiles the raw view code into a function which will render the 
# view out as HTML.

LDB.renderTemplate = (templateString) ->
  LDB._compiledHandlebars ?= {}
  i = LDB._compiledHandlebars.length
  return ->
    LDB._compiledHandlebars[i] ?= Handlebars.compile(templateString)
    return LDB._compiledHandlebars[i](arguments[0], arguments[1])

# We then set the default renderer to pull out the view
Backbone.View.prototype.render = ->
  $(@el).html(LDB.ViewRenderers[@view_path](@model.toJSON()))
  return this



# Start the application
Backbone.history = new Backbone.History
Backbone.history.start()
