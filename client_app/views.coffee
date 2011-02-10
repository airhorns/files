# Path setup
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
  return (data, fallback)->
    LDB._compiledHandlebars[i] ?= Handlebars.compile(templateString) # lazily compile the template at the index
    return LDB._compiledHandlebars[i](data, fallback)

# Base View class, all views in the application extend this bad boy
class LDB.View extends Backbone.View

  # Used by render to pass something to the view. Usually, this
  # is the attributes of the model the view is representing, but
  # this is overridden by some views.
  renderable: ->
    if @model?
      @model.toJSON()
    else
      {}

  # To render, it finds the compiled Handlebars templates using the 
  # #getBars method. This hits LDB.ViewRenderers array which is 
  # populated by Jammit calling the stuff up there. LDB.View executes
  # the template by passing in whatever comes back from #renderable,
  # and stuffs the generated HTML into @el. It then runs any after 
  # render callbacks that were queued up by helpers used during
  # rendering. Phew.
  render: ->
    renderable = this.renderable()
    $(@el).html(this.getBars()(renderable))
    cb() for cb in renderable._afterCallbacks if renderable._afterCallbacks?
    return this

  # Internal method to find the compiled Handlebars template.
  getBars: ->
    LDB.ViewRenderers[@view_path]

# Default handlebars helpers
Handlebars.registerHelper 'after', (fn, args...) ->
  self = this
  this._afterCallbacks ||= []
  this._afterCallbacks.push -> fn.apply(self, args)

# Growl style notifications for the user
LDB.notify = (textOrOptions) ->
  options =
    timeout: 4
    icon: 'ui-icon-info'
  if _.isString(textOrOptions)
    options.message = textOrOptions
  else
    options = _.extend {}, options, textOrOptions
  $.achtung options
