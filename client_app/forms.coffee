# Handlebars block helpers for building forms. Sucks moving away from Rails eh?
CURRENT_FORM = false
ss = (str) ->
  new Handlebars.SafeString(str)

class FormBuilder
  name: ""
  context: {}
  current_select: false
  constructor: (name, context) ->
    @name = name
    @context = context
  
  getValue: (name) ->
    if @context[name]? then @context[name] else ''

  # Form block wrapper, must enclose calls to the other helpers in one of these
  form_for: (fn) ->
    ss "<form accept-charset=\"UTF-8\" action=\"#\" class=\"new_#{@name}\">#{fn(@context)}</form>"

  # Field renderer, can either be the wrapper div or as a shortcut do the whole field as a text input
  field: (nameOrFn) ->
    if _.isString(nameOrFn)
      # {{field "something"}} shortcut style calling, parameter is a name
      out = this.label(nameOrFn)
      out += "\n" + this.text(nameOrFn)
    else
      # {{#field}}...{{/field}} style calling, parameter is a function
      out = nameOrFn(@context)

    ss "<div class=\"field\">#{out}</div>"
  
  # Label renderer
  label: (name, title) ->
    title ||= name.replace('_', ' ').replace(' id','').titleize()
    ss "<label for=\"#{@name}_#{name}\">#{title}</label>"

  # Text input renderer
  text: (name) ->
    ss "<input id=\"#{@name}_#{name}\" name=\"#{@name}[#{name}]\" value=\"#{this.getValue(name)}\"/>"

  # Select input helper
  select: (name, options, fn) ->
    throw "Select needs options!" unless options?
    @current_select = name # Set this value for use in option select
    if fn?
      # {{#select name options}} block helper which allows inline option rendering
      out = (fn(option) for option in options)
    else
      # {{select "name" path}} shortcut helper which renders its own options
      out = (this.option(option.name, option.value, option.selected) for option in options)
    @current_select = false
    ss "<select id=\"#{@name}_#{name}\" name=\"#{@name}[#{name}]\">#{out.join('')}</select>"
  
  # Option tag helper. Value and Selected tag optional
  option: (name, value, selected) ->
    throw "Can't call option tag unless wrapped in a select" unless @current_select
    selected_value = this.getValue(@current_select) # Pull out the value of the option that should be selected
    selected_text = if selected or selected_value == value then " selected=\"selected\"" else ""
    value_text = if value? then " value=\"#{value}\"" else ""
    ss "<option#{value_text}#{selected_text}>#{name}</option>"
  
  # Hidden input helper
  hidden: (name) ->
    ss "<input type=\"hidden\" id=\"#{@name}_#{name}\" name=\"#{@name}[#{name}]\" value=\"#{this.getValue(name)}\"/>"

  # Date input helper
  date: (name) ->
    id = "#{@name}_#{name}"
    Handlebars.helpers.after.call @context, ->
      jQuery("##{id}").datepicker
        changeMonth: true
        changeYear: true
        showButtonPanel: true

    ss "<input type=\"date\" id=\"#{id}\" name=\"#{@name}[#{name}]\" value=\"#{this.getValue(name)}\"/>"

  # Time input helper
  time: (name) ->
    id = "#{@name}_#{name}"
    Handlebars.helpers.after.call @context, ->
      jQuery("##{id}").timePicker
        startTime: "00:00"
        endTime: "23:59"
        show24Hours: false
        step: 30
      
    ss "<input type=\"time\" id=\"#{id}\" name=\"#{@name}[#{name}]\" value=\"#{this.getValue(name)}\"/>"

for name in ['field', 'label', 'text', 'select', 'option', 'hidden', 'date', 'time']
  do (name) ->
    Handlebars.registerHelper name, () ->
      unless CURRENT_FORM
        throw "Can't use the form helpers outside of a form! Try wrapping them in a form_for block."
      else
        throw "Unknown form helper #{name}! This shouldn't happen!" unless CURRENT_FORM[name]?
        CURRENT_FORM[name].apply(CURRENT_FORM, arguments)


Handlebars.registerHelper 'form_for', (name, fn) ->
  CURRENT_FORM = new FormBuilder(name, this)
  out = CURRENT_FORM.form_for(fn)
  CURRENT_FORM = false
  return out

Handlebars.registerHelper 'after', (fn, args...) ->
  self = this
  this._afterCallbacks ||= []
  this._afterCallbacks.push -> fn.apply(self, args)

Handlebars.registerHelper 'helperMissing', (name, fn) ->
  throw "No helper by the name of #{name}!"
