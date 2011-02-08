# Handlebars block helpers for building forms. Sucks moving away from Rails eh?
currentForm = false
ss = (str) ->
  new Handlebars.SafeString(str)

Handlebars.registerHelper 'helperMissing', (name, fn) ->
  throw "No helper by the name of #{name}!"

# Form wrapper
Handlebars.registerHelper 'form_for', (name, fn) ->
  currentForm = name
  out =  ss "<form accept-charset=\"UTF-8\" action=\"#\" class=\"new_#{name}\">#{fn(this)}</form>"
  currentForm = false
  return out
  
# Field renderer, can either be the wrapper div or as a shortcut do the whole field as a text input
Handlebars.registerHelper 'field', (nameOrFn) ->
  if _.isString(nameOrFn)
    # {{field "something"}} shortcut style calling, parameter is a name
    out = Handlebars.helpers['label'].call(this, nameOrFn)
    out += "\n" + Handlebars.helpers['text'].call(this, nameOrFn)
  else
    # {{#field}}...{{/field}} style calling, parameter is a function
    out = nameOrFn(this)

  ss "<div class=\"field\">
  #{out}
</div>"

# Label renderer
Handlebars.registerHelper 'label', (name) ->
  ss "<label for=\"#{currentForm}_#{name}\">#{name.replace('_id', '').capitalize()}</label>"

# Text input renderer
Handlebars.registerHelper 'text', (name) -> ss "<input id=\"#{currentForm}_#{name}\" name=\"#{currentForm}[#{name}]\" value=\"#{if this[name]? then this[name] else ''}\"/>"

source = "<ul>{{#people}}<li>{{#link}}goddamint: {{name}}{{/link}}</li>{{/people}}</ul>"
Handlebars.registerHelper 'link', (fn) ->
  return '<a href="/people/' + this.id + '">' + fn(this) + '</a>'

template = Handlebars.compile(source)
data =
  people: [{
    name: "Alan"
    id: 1
  },{
    name: "Yehuda"
    id: 2
  }]
