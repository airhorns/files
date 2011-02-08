(function() {
  var currentForm, data, source, ss, template;
  currentForm = false;
  ss = function(str) {
    return new Handlebars.SafeString(str);
  };
  Handlebars.registerHelper('helperMissing', function(name, fn) {
    throw "No helper by the name of " + name + "!";
  });
  Handlebars.registerHelper('form_for', function(name, fn) {
    var out;
    currentForm = name;
    out = ss("<form accept-charset=\"UTF-8\" action=\"#\" class=\"new_" + name + "\">" + (fn(this)) + "</form>");
    currentForm = false;
    return out;
  });
  Handlebars.registerHelper('field', function(nameOrFn) {
    var out;
    if (_.isString(nameOrFn)) {
      out = Handlebars.helpers['label'].call(this, nameOrFn);
      out += "\n" + Handlebars.helpers['text'].call(this, nameOrFn);
    } else {
      out = nameOrFn(this);
    }
    return ss("<div class=\"field\">  " + out + "</div>");
  });
  Handlebars.registerHelper('label', function(name) {
    return ss("<label for=\"" + currentForm + "_" + name + "\">" + (name.replace('_id', '').capitalize()) + "</label>");
  });
  Handlebars.registerHelper('text', function(name) {
    return ss("<input id=\"" + currentForm + "_" + name + "\" name=\"" + currentForm + "[" + name + "]\" value=\"" + (this[name] != null ? this[name] : '') + "\"/>");
  });
  source = "<ul>{{#people}}<li>{{#link}}goddamint: {{name}}{{/link}}</li>{{/people}}</ul>";
  Handlebars.registerHelper('link', function(fn) {
    return '<a href="/people/' + this.id + '">' + fn(this) + '</a>';
  });
  template = Handlebars.compile(source);
  data = {
    people: [
      {
        name: "Alan",
        id: 1
      }, {
        name: "Yehuda",
        id: 2
      }
    ]
  };
}).call(this);
