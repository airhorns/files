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
      describe('rendering', function() {
        it("should render the view", function() {
          var view;
          view = new this.klass;
          view.render();
          return expect(view.el).toHaveHTML("Value: y");
        });
        return it("should be chainable when rendering", function() {
          var view;
          view = new this.klass;
          return expect(view.render()).toEqual(view);
        });
      });
      return describe('callbacks', function() {
        it("should fire the class level after callback and pass the renderable", function() {
          var AfteRenderClass, afterCallback, klass;
          afterCallback = jasmine.createSpy();
          klass = AfteRenderClass = (function() {
            function AfteRenderClass() {
              AfteRenderClass.__super__.constructor.apply(this, arguments);
            }
            __extends(AfteRenderClass, this.klass);
            AfteRenderClass.prototype.afterRender = afterCallback;
            return AfteRenderClass;
          }).call(this);
          (new klass).render();
          return expect(afterCallback).toHaveBeenCalledWith({
            x: "y"
          });
        });
        return it("should fire the after callbacks set in helpers", function() {
          var AfterTestClass, afterCallback, helperTestTemplate, klass, view;
          afterCallback = jasmine.createSpy();
          Handlebars.registerHelper("test", function() {
            Handlebars.helpers.after.call(this, afterCallback, "an_argument", "another");
            return "123";
          });
          helperTestTemplate = Handlebars.compile("Test: {{test}}");
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
          return expect(afterCallback).toHaveBeenCalledWith("an_argument", "another");
        });
      });
    });
  });
}).call(this);
