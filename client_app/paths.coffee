window.LDB =
  Views: {}
  ViewRenderers: {}
  _compiledHandlebars: {}

# The LDB.Views object is populated by creating view classes and LDB.registerView'ing them.
# This way, there is a central place to find and render views, and definitive path uniqueness
# for them. They can be looked up using LDB.Views[path], ie LDB.Views['application/application'] or
# LDB.Views['logs/new'], or using LDB.view('')

LDB.registerView = (name, klass) ->
  klass::view_path = name
  LDB.Views[name] = klass

LDB.view = (name) ->
  LDB.Views[name]

# The LDB.ViewRenderers object is populated by the Jammit asset packager. 
# Views are pulled from client_app/views and put into the object using their path as keys,
# so you can expect to see things like LDB.ViewRenderers['logs/index'] to pull out the view.
# The function below compiles the raw view code into a function which will render the 
# view out as HTML.
compiledCounter = -1
LDB.renderTemplate = (templateString) ->
  i = compiledCounter++ # close over index
  return ->
    LDB._compiledHandlebars[i] ?= Handlebars.compile(templateString) # lazily compile the template at the index
    return LDB._compiledHandlebars[i](arguments[0], arguments[1])

# We set the default renderer to pull out the view.
Backbone.View.prototype.renderable = ->
  if @model?
    @model.toJSON()
  else
    {}

Backbone.View.prototype.render = ->
  $(@el).html(LDB.ViewRenderers[@view_path](this.renderable()))
  return this
