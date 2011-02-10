fmt = (str) ->
  (str || "").replace(/\s{2,}/g, ' ').replace(/\n/g, ' ').replace(/>\s*</g,'><')

require '/lib/handlebars/handlebars.js', '/lib/backbone/backbone.js', '/javascripts/forms.js', ->

  describe "Handlebars Form Helpers", ->
    beforeEach ->
      this.addMatchers
        toRenderTo: (expected,model={}) ->
          template = Handlebars.compile(this.actual)
          this.actual = template(model)
          a = (fmt this.actual)
          b = (fmt expected)

          result = a == b
          result

    it "should render a basic field.", ->
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

    it "should allow overriding the label title, and properly generate it if not given", ->
      template = '{{#form_for "log"}}
                    {{#field}}
                      {{label "show_id"}}
                      {{label "show_date"}}
                      {{label "show_id" "Show Name"}}
                    {{/field}}
                  {{/form_for}}'
      output = '<form accept-charset="UTF-8" action="#" class="new_log">
                  <div class="field">
                    <label for="log_show_id">Show</label>
                    <label for="log_show_date">Show Date</label>
                    <label for="log_show_id">Show Name</label>
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

    describe 'select tag rendering', ->
      beforeEach ->
        @model =
          show_id: 2
          data: [{name:"a", value:1},{name:"b", value:2, selected:true}]
        @output = '<form accept-charset="UTF-8" action="#" class="new_log">
                      <select id="log_show_id" name="log[show_id]">
                        <option value="1">a</option>
                        <option value="2" selected="selected">b</option>
                      </select>
                  </form>'

      it "should render a select input and options", ->
        template = '{{#form_for "log"}}
                      {{#select "show_id" data}}
                        {{option name value}}
                      {{/select}}
                    {{/form_for}}'
        expect(template).toRenderTo(@output, @model)

       it "should render a select label and input with nonstandard", ->
          @model =
            qux: [{foo:"a", bar:1},{foo:"b", bar:2, baz:true}]
          template = '{{#form_for "log"}}
                        {{#select "show_id" qux}}
                          {{option foo bar baz}}
                        {{/select}}
                      {{/form_for}}'
          expect(template).toRenderTo(@output, @model)

       it "should render a select label and input using a shortcut.", ->
          shortcutTemplate = '{{#form_for "log"}}
                        {{select "show_id" data}}
                      {{/form_for}}'

          expect(shortcutTemplate).toRenderTo(@output, @model)
 
      it "should render a options without value tags if there are no values", ->
        @model =
            data: [{name:"a"},{name:"b"}]
          template = '{{#form_for "log"}}
                        {{select "show_id" data}}        
                      {{/form_for}}'
          output = '<form accept-charset="UTF-8" action="#" class="new_log">
                        <select id="log_show_id" name="log[show_id]">
                          <option>a</option>
                          <option>b</option>
                        </select>
                    </form>'

          expect(template).toRenderTo(output, @model)

    it "should render a hidden field and pull out the value.", ->
      template = '{{#form_for "log"}}
                      {{hidden "show_id"}}
                  {{/form_for}}'
      output = '<form accept-charset="UTF-8" action="#" class="new_log">
                    <input type="hidden" id="log_show_id" name="log[show_id]" value="42"/>
                </form>'
      expect(template).toRenderTo(output, {show_id: 42})
    
    it "should render a date field", ->
      template = '{{#form_for "log"}}
                      {{date "show_start"}}
                  {{/form_for}}'
      output = '<form accept-charset="UTF-8" action="#" class="new_log">
                    <input type="date" id="log_show_start" name="log[show_start]" value="10/20/2011"/>
                </form>'
      expect(template).toRenderTo(output, {show_start: '10/20/2011'})

    it "should render a time field", ->
      template = '{{#form_for "log"}}
                      {{time "show_start"}}
                  {{/form_for}}'
      output = '<form accept-charset="UTF-8" action="#" class="new_log">
                    <input type="time" id="log_show_start" name="log[show_start]" value="10:27 AM"/>
                </form>'
      expect(template).toRenderTo(output, {show_start: '10:27 AM'})
    true
