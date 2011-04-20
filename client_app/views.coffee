# Path setup
_.extend FDB,
  Views: {}
  ViewRenderers: {}
  _compiledHandlebars: {}

# The FDB.Views object is populated by creating view classes and FDB.registerView'ing them.
# This way, there is a central place to find and render views, and definitive path uniqueness
# for them. They can be looked up using FDB.Views[path], ie FDB.Views['application/application'] or
# FDB.Views['logs/new'], or using FDB.view('')

FDB.registerView = (name, klass) ->
  klass::view_path = name
  FDB.Views[name] = klass

FDB.view = (name) ->
  FDB.Views[name]

# The FDB.ViewRenderers object is populated by the Jammit asset packager. 
# Views are pulled from client_app/views and put into the object using their path as keys,
# so you can expect to see things like FDB.ViewRenderers['logs/index'] to pull out the view.
# The function below compiles the raw view code into a function which will render the 
# view out as HTML.
compiledCounter = -1
FDB.renderTemplate = (templateString) ->
  i = compiledCounter++ # close over index
  return (data, fallback) ->
    FDB._compiledHandlebars[i] ?= Handlebars.compile(templateString) # lazily compile the template at the index
    return FDB._compiledHandlebars[i](data, fallback)

# Base View class, all views in the application extend this bad boy
class FDB.View extends Backbone.View

  # Used by render to pass something to the view. Usually, this
  # is the attributes of the model the view is representing, but
  # this is overridden by some views.
  renderable: ->
    if @model?
      @model.toJSON()
    else
      {}

  # To render, it finds the compiled Handlebars templates using the 
  # #getBars method. This hits FDB.ViewRenderers array which is 
  # populated by Jammit calling the stuff up there. FDB.View executes
  # the template by passing in whatever comes back from #renderable,
  # and stuffs the generated HTML into @el. It then runs any after 
  # render callbacks that were queued up by helpers used during
  # rendering. Phew.
  render: ->
    renderable = this.renderable()
    $(@el).html(this.getBars()(renderable))
    cb(renderable) for cb in renderable._afterCallbacks if renderable._afterCallbacks?
    this.afterRender(renderable) if this.afterRender?
    return this

  # Internal method to find the compiled Handlebars template.
  getBars: ->
    FDB.ViewRenderers[@view_path]

# Default handlebars helpers
Handlebars.registerHelper 'after', (fn, args...) ->
  self = this
  this._afterCallbacks ||= []
  this._afterCallbacks.push -> fn.apply(self, args)

# Growl style notifications for the user
FDB.notify = (textOrOptions) ->
  options =
    timeout: 4
    icon: 'ui-icon-info'
  if _.isString(textOrOptions)
    options.message = textOrOptions
  else
    options = _.extend {}, options, textOrOptions
  $.achtung options


# Hook into the Handlebars compiler public API to allow for slashes in names
Handlebars.JavaScriptCompiler.prototype.nameLookup = (parent, name, type) ->
  if(Handlebars.JavaScriptCompiler.RESERVED_WORDS[name] || name.indexOf('/') != -1)
    return parent + "['" + name + "']"
  else
    return parent + "." + name
