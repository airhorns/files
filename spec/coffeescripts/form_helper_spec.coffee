fmt = (str) ->
  str.replace(/\s{2,}/g, ' ').replace(/\n/g, ' ').replace(/>\s*</g,'><')

require '/lib/handlebars/handlebars.js', '/lib/backbone/backbone.js', '/javascripts/forms.js', ->

  describe "Handlebars Form Helpers", ->
    beforeEach ->
      this.addMatchers
        toRenderTo: (expected,model={}) ->
          template = Handlebars.compile(this.actual)
          this.actual = template(model)
          result = (fmt this.actual) == (fmt expected)
          unless result
            debugger
          result

    it "should render a field.", ->
      template = '{{#form_for "log"}}
                    {{#field}}
                      {{label "show_id"}}
                      {{text "show_id"}}
                    {{/field}}
                  {{/form_for}}'
      output = '<form accept-charset="UTF-8" action="#" class="new_log">
                  <div class="field">
                    <label for="log_show_id">Show</label>
                    <input id="log_show_id" name="log[show_id]" value=""/>
                  </div>
                </form>'
      expect(template).toRenderTo(output)
    
    it "should render a field and pull out the value.", ->
      template = '{{#form_for "log"}}
                    {{#field}}
                      {{label "show_id"}}
                      {{text "show_id"}}
                    {{/field}}
                  {{/form_for}}'
      output = '<form accept-charset="UTF-8" action="#" class="new_log">
                  <div class="field">
                    <label for="log_show_id">Show</label>
                    <input id="log_show_id" name="log[show_id]" value="42"/>
                  </div>
                </form>'
      expect(template).toRenderTo(output, {show_id: 42})

    it "should render the label and input using a shortcut.", ->
      template = '{{#form_for "log"}}
                    {{field "show_id"}}
                  {{/form_for}}'
      output = '<form accept-charset="UTF-8" action="#" class="new_log">
                  <div class="field">
                    <label for="log_show_id">Show</label>
                    <input id="log_show_id" name="log[show_id]" value=""/>
                  </div>
                </form>'

      expect(template).toRenderTo(output)
