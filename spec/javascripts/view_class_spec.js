(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  require('/lib/handlebars/handlebars.js', '/lib/backbone/backbone.js', '/javascripts/forms.js', '/javascripts/views.js', function() {
    return describe("LDB.View", function() {
      var compiledTemplate, standardHelpers, template;
      template = 'Value: {{x}}';
      compiledTemplate = Handlebars.compile(template);
      standardHelpers = Handlebars.helpers;
      beforeEach(function() {
        var ViewKlass;
        Handlebars.helpers = _.clone(standardHelpers);
        return this.klass = ViewKlass = (function() {
          function ViewKlass() {
            ViewKlass.__super__.constructor.apply(this, arguments);
          }
          __extends(ViewKlass, LDB.View);
          ViewKlass.prototype.renderable = function() {
            return {
              x: "y"
            };
          };
          ViewKlass.prototype.getBars = function() {
            return compiledTemplate;
          };
          return ViewKlass;
        })();
      });
      it("should render the view", function() {
        var view;
        view = new this.klass;
        view.render();
        return expect(view.el).toHaveHTML("Value: y");
      });
      return it("should fire the after callbacks", function() {
        var AfterTestClass, afterCallback, helperTestTemplate, klass, view;
        afterCallback = jasmine.createSpy();
        helperTestTemplate = Handlebars.compile("Test: {{test}}");
        Handlebars.registerHelper("test", function() {
          Handlebars.helpers.after.call(this, afterCallback);
          return "123";
        });
        klass = AfterTestClass = (function() {
          function AfterTestClass() {
            AfterTestClass.__super__.constructor.apply(this, arguments);
          }
          __extends(AfterTestClass, this.klass);
          AfterTestClass.prototype.getBars = function() {
            return helperTestTemplate;
          };
          return AfterTestClass;
        }).call(this);
        view = new klass;
        view.render();
        expect(view.el).toHaveHTML("Test: 123");
        return expect(afterCallback).toHaveBeenCalled();
      });
    });
  });
}).call(this);
