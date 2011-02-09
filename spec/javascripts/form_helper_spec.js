(function() {
  var fmt;
  fmt = function(str) {
    return (str || "").replace(/\s{2,}/g, ' ').replace(/\n/g, ' ').replace(/>\s*</g, '><');
  };
  require('/lib/handlebars/handlebars.js', '/lib/backbone/backbone.js', '/javascripts/forms.js', function() {
    return describe("Handlebars Form Helpers", function() {
      beforeEach(function() {
        return this.addMatchers({
          toRenderTo: function(expected, model) {
            var a, b, result, template;
            if (model == null) {
              model = {};
            }
            template = Handlebars.compile(this.actual);
            this.actual = template(model);
            a = fmt(this.actual);
            b = fmt(expected);
            result = a === b;
            return result;
          }
        });
      });
      it("should render a basic field.", function() {
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
      it("should allow overriding the label title, and properly generate it if not given", function() {
        var output, template;
        template = '{{#form_for "log"}}\
                    {{#field}}\
                      {{label "show_id"}}\
                      {{label "show_date"}}\
                      {{label "show_id" "Show Name"}}\
                    {{/field}}\
                  {{/form_for}}';
        output = '<form accept-charset="UTF-8" action="#" class="new_log">\
                  <div class="field">\
                    <label for="log_show_id">Show</label>\
                    <label for="log_show_date">Show Date</label>\
                    <label for="log_show_id">Show Name</label>\
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
      it("should render the label and input using a shortcut.", function() {
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
      describe('select tag rendering', function() {
        beforeEach(function() {
          this.model = {
            show_id: 2,
            data: [
              {
                name: "a",
                value: 1
              }, {
                name: "b",
                value: 2,
                selected: true
              }
            ]
          };
          return this.output = '<form accept-charset="UTF-8" action="#" class="new_log">\
                      <select id="log_show_id" name="log[show_id]">\
                        <option value="1">a</option>\
                        <option value="2" selected="selected">b</option>\
                      </select>\
                  </form>';
        });
        it("should render a select input and options", function() {
          var template;
          template = '{{#form_for "log"}}\
                      {{#select "show_id" data}}\
                        {{option name value}}\
                      {{/select}}\
                    {{/form_for}}';
          return expect(template).toRenderTo(this.output, this.model);
        });
        it("should render a select label and input with nonstandard", function() {
          var template;
          this.model = {
            qux: [
              {
                foo: "a",
                bar: 1
              }, {
                foo: "b",
                bar: 2,
                baz: true
              }
            ]
          };
          template = '{{#form_for "log"}}\
                        {{#select "show_id" qux}}\
                          {{option foo bar baz}}\
                        {{/select}}\
                      {{/form_for}}';
          return expect(template).toRenderTo(this.output, this.model);
        });
        it("should render a select label and input using a shortcut.", function() {
          var shortcutTemplate;
          shortcutTemplate = '{{#form_for "log"}}\
                        {{select "show_id" data}}\
                      {{/form_for}}';
          return expect(shortcutTemplate).toRenderTo(this.output, this.model);
        });
        return it("should render a options without value tags if there are no values", function() {
          var output, template;
          this.model = {
            data: [
              {
                name: "a"
              }, {
                name: "b"
              }
            ]
          };
          template = '{{#form_for "log"}}\
                        {{select "show_id" data}}        \
                      {{/form_for}}';
          output = '<form accept-charset="UTF-8" action="#" class="new_log">\
                        <select id="log_show_id" name="log[show_id]">\
                          <option>a</option>\
                          <option>b</option>\
                        </select>\
                    </form>';
          return expect(template).toRenderTo(output, this.model);
        });
      });
      it("should render a hidden field and pull out the value.", function() {
        var output, template;
        template = '{{#form_for "log"}}\
                      {{hidden "show_id"}}\
                  {{/form_for}}';
        output = '<form accept-charset="UTF-8" action="#" class="new_log">\
                    <input type="hidden" id="log_show_id" name="log[show_id]" value="42"/>\
                </form>';
        return expect(template).toRenderTo(output, {
          show_id: 42
        });
      });
      it("should render a date field", function() {
        var output, template;
        template = '{{#form_for "log"}}\
                      {{date "show_start"}}\
                  {{/form_for}}';
        output = '<form accept-charset="UTF-8" action="#" class="new_log">\
                    <input id="log_show_start" name="log[show_start]" value="10/20/2011" data-datepicker="true"/>\
                </form>';
        return expect(template).toRenderTo(output, {
          show_start: '10/20/2011'
        });
      });
      return true;
    });
  });
}).call(this);
