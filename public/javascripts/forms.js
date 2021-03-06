(function() {
  var CURRENT_FORM, FormBuilder, name, ss, _fn, _i, _len, _ref;
  CURRENT_FORM = false;
  ss = function(str) {
    return new Handlebars.SafeString(str);
  };
  FormBuilder = (function() {
    FormBuilder.prototype.name = "";
    FormBuilder.prototype.context = {};
    FormBuilder.prototype.current_select = false;
    function FormBuilder(name, context) {
      this.name = name;
      this.context = context;
    }
    FormBuilder.prototype.getValue = function(name) {
      if (this.context[name] != null) {
        return this.context[name];
      } else {
        return '';
      }
    };
    FormBuilder.prototype.form_for = function(fn) {
      return ss("<form accept-charset=\"UTF-8\" action=\"#\" class=\"new_" + this.name + "\">" + (fn(this.context)) + "</form>");
    };
    FormBuilder.prototype.field = function(nameOrFn) {
      var out;
      if (_.isString(nameOrFn)) {
        out = this.label(nameOrFn);
        out += "\n" + this.text(nameOrFn);
      } else {
        out = nameOrFn(this.context);
      }
      return ss("<div class=\"field\">" + out + "</div>");
    };
    FormBuilder.prototype.inline_field = function(nameOrFn) {
      var out;
      if (_.isString(nameOrFn)) {
        out = this.label(nameOrFn);
        out += "\n" + this.text(nameOrFn);
      } else {
        out = nameOrFn(this.context);
      }
      return ss("<div class=\"field inline\">" + out + "</div>");
    };
    FormBuilder.prototype.label = function(name, title) {
      title || (title = name.replace('_', ' ').replace(' id', '').titleize());
      return ss("<label for=\"" + this.name + "_" + name + "\">" + title + "</label>");
    };
    FormBuilder.prototype.text = function(name) {
      return ss("<input id=\"" + this.name + "_" + name + "\" name=\"" + this.name + "[" + name + "]\" value=\"" + (this.getValue(name)) + "\"/>");
    };
    FormBuilder.prototype.select = function(name, options, fn) {
      var id, option, out;
      if (options == null) {
        throw "Select needs options!";
      }
      this.current_select = name;
      if (fn != null) {
        out = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = options.length; _i < _len; _i++) {
            option = options[_i];
            _results.push(fn(option));
          }
          return _results;
        })();
      } else {
        out = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = options.length; _i < _len; _i++) {
            option = options[_i];
            _results.push(this.option(option.name, option.value, option.selected));
          }
          return _results;
        }).call(this);
      }
      this.current_select = false;
      id = "" + this.name + "_" + name;
      Handlebars.helpers.after.call(this.context, function() {
        return jQuery("#" + id).uniform();
      });
      return ss("<select id=\"" + id + "\" name=\"" + this.name + "[" + name + "]\">" + (out.join('')) + "</select>");
    };
    FormBuilder.prototype.option = function(name, value, selected) {
      var selected_text, selected_value, value_text;
      if (!this.current_select) {
        throw "Can't call option tag unless wrapped in a select";
      }
      selected_value = this.getValue(this.current_select);
      selected_text = selected || selected_value === value ? " selected=\"selected\"" : "";
      value_text = value != null ? " value=\"" + value + "\"" : "";
      return ss("<option" + value_text + selected_text + ">" + name + "</option>");
    };
    FormBuilder.prototype.hidden = function(name) {
      return ss("<input type=\"hidden\" id=\"" + this.name + "_" + name + "\" name=\"" + this.name + "[" + name + "]\" value=\"" + (this.getValue(name)) + "\"/>");
    };
    FormBuilder.prototype.date = function(name) {
      var id;
      id = "" + this.name + "_" + name;
      Handlebars.helpers.after.call(this.context, function() {
        return jQuery("#" + id).datepicker({
          changeMonth: true,
          changeYear: true,
          showButtonPanel: true
        });
      });
      return ss("<input type=\"date\" id=\"" + id + "\" name=\"" + this.name + "[" + name + "]\" value=\"" + (this.getValue(name)) + "\"/>");
    };
    FormBuilder.prototype.time = function(name) {
      var id;
      id = "" + this.name + "_" + name;
      Handlebars.helpers.after.call(this.context, function() {
        return jQuery("#" + id).timePicker({
          startTime: "00:00",
          endTime: "23:59",
          show24Hours: false,
          step: 30
        });
      });
      return ss("<input type=\"time\" id=\"" + id + "\" name=\"" + this.name + "[" + name + "]\" value=\"" + (this.getValue(name)) + "\"/>");
    };
    FormBuilder.prototype.checkbox = function(name) {
      var checked, id;
      id = "" + this.name + "_" + name;
      Handlebars.helpers.after.call(this.context, function() {
        return jQuery("#" + id).uniform();
      });
      checked = this.getValue(name) ? ' checked="checked"' : '';
      return ss("<input type=\"checkbox\" id=\"" + id + "\" name=\"" + this.name + "[" + name + "]\" value=\"true\"" + checked + "/>");
    };
    FormBuilder.prototype.button = function(text, type) {
      var id;
      if (type == null) {
        type = "submit";
      }
      id = "" + this.name + "_" + type;
      Handlebars.helpers.after.call(this.context, function() {
        return $("#" + id).button();
      });
      return ss("<input id=\"" + id + "\" type=\"submit\" value=\"" + text + "\"/>");
    };
    FormBuilder.prototype.submit = function(text) {
      if (text == null) {
        text = "Save";
      }
      return this.button(text, "submit");
    };
    return FormBuilder;
  })();
  _ref = ['field', 'inline_field', 'label', 'text', 'select', 'option', 'hidden', 'date', 'time', 'checkbox', 'button', 'submit'];
  _fn = function(name) {
    return Handlebars.registerHelper(name, function() {
      if (!CURRENT_FORM) {
        throw "Can't use the form helpers outside of a form! Try wrapping them in a form_for block.";
      } else {
        if (CURRENT_FORM[name] == null) {
          throw "Unknown form helper " + name + "! This shouldn't happen!";
        }
        return CURRENT_FORM[name].apply(CURRENT_FORM, arguments);
      }
    });
  };
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    name = _ref[_i];
    _fn(name);
  }
  Handlebars.registerHelper('form_for', function(name, fn) {
    var out;
    CURRENT_FORM = new FormBuilder(name, this);
    out = CURRENT_FORM.form_for(fn);
    CURRENT_FORM = false;
    return out;
  });
  Handlebars.registerHelper('helperMissing', function(name, fn) {
    throw "No helper by the name of " + name + "!";
  });
}).call(this);
