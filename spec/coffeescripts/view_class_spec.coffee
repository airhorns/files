require '/lib/handlebars/handlebars.js', '/lib/backbone/backbone.js', '/javascripts/forms.js', '/javascripts/views.js', ->

  describe "LDB.View", ->
    template = 'Value: {{x}}'
    compiledTemplate = Handlebars.compile(template)
    standardHelpers = Handlebars.helpers

    beforeEach ->
      Handlebars.helpers = _.clone standardHelpers
      @klass = class ViewKlass extends LDB.View
        renderable: ->
          x: "y"

        getBars: ->
          compiledTemplate # Mock out the template, usually provided by Jammit

    describe 'rendering', ->
      it "should render the view", ->
        view = new @klass
        view.render()
        expect(view.el).toHaveHTML("Value: y")
    
      it "should be chainable when rendering", ->
        view = new @klass
        expect(view.render()).toEqual(view)

    describe 'callbacks', ->
      it "should fire the class level after callback and pass the renderable", ->
        afterCallback = jasmine.createSpy()
        klass = class AfteRenderClass extends @klass
          afterRender: afterCallback

        (new klass).render()
        expect(afterCallback).toHaveBeenCalledWith({x: "y"})

      it "should fire the after callbacks set in helpers", ->
        afterCallback = jasmine.createSpy()
        
        Handlebars.registerHelper "test", () ->
          Handlebars.helpers.after.call this, afterCallback, "an_argument", "another"
          return "123"

        helperTestTemplate = Handlebars.compile("Test: {{test}}")
        klass = class AfterTestClass extends @klass
          getBars: ->
            helperTestTemplate

        view = new klass
        view.render()
        expect(view.el).toHaveHTML("Test: 123") # That the thing actually rendered and the helper worked
        expect(afterCallback).toHaveBeenCalledWith("an_argument", "another")
