(function() {
  var fmt;
  fmt = function(str) {
    return str.replace(/\s{2,}/g, ' ').replace(/\n/g, ' ').replace(/>\s*</g, '><');
  };
  require('/lib/handlebars/handlebars.js', '/lib/backbone/backbone.js', '/javascripts/forms.js', function() {
    return describe("Handlebars Form Helpers", function() {
      beforeEach(function() {
        return this.addMatchers({
          toRenderTo: function(expected, model) {
            var result, template;
            if (model == null) {
              model = {};
            }
            template = Handlebars.compile(this.actual);
            this.actual = template(model);
            result = (fmt(this.actual)) === (fmt(expected));
            if (!result) {
              debugger;
            }
            return result;
          }
        });
      });
      it("should render a field.", function() {
        var output, template;
        template = '{{#form_for "log"}}\
                    {{#field}}\
                      {{label "show_id"}}\
                      {{text "show_id"}}\
                    {{/field}}\
                  {{/form_for}}';
        output = '<form accept-charset="UTF-8" action="#" class="new_log">\
                  <div class="field">\
                    <label for="log_show_id">Show</label>\
                    <input id="log_show_id" name="log[show_id]" value=""/>\
                  </div>\
                </form>';
        return expect(template).toRenderTo(output);
      });
      it("should render a field and pull out the value.", function() {
        var output, template;
        template = '{{#form_for "log"}}\
                    {{#field}}\
                      {{label "show_id"}}\
                      {{text "show_id"}}\
                    {{/field}}\
                  {{/form_for}}';
        output = '<form accept-charset="UTF-8" action="#" class="new_log">\
                  <div class="field">\
                    <label for="log_show_id">Show</label>\
                    <input id="log_show_id" name="log[show_id]" value="42"/>\
                  </div>\
                </form>';
        return expect(template).toRenderTo(output, {
          show_id: 42
        });
      });
      return it("should render the label and input using a shortcut.", function() {
        var output, template;
        template = '{{#form_for "log"}}\
                    {{field "show_id"}}\
                  {{/form_for}}';
        output = '<form accept-charset="UTF-8" action="#" class="new_log">\
                  <div class="field">\
                    <label for="log_show_id">Show</label>\
                    <input id="log_show_id" name="log[show_id]" value=""/>\
                  </div>\
                </form>';
        return expect(template).toRenderTo(output);
      });
    });
  });
}).call(this);
