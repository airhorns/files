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
    
    it "should render the view", ->
      view = new @klass
      view.render()
      expect(view.el).toHaveHTML("Value: y")

    it "should fire the after callbacks", ->
      afterCallback = jasmine.createSpy()
      helperTestTemplate = Handlebars.compile("Test: {{test}}")

      Handlebars.registerHelper "test", () ->
        Handlebars.helpers.after.call this, afterCallback
        return "123"

      klass = class AfterTestClass extends @klass
        getBars: ->
          helperTestTemplate
      view = new klass
      view.render()
      expect(view.el).toHaveHTML("Test: 123")

      expect(afterCallback).toHaveBeenCalled()
