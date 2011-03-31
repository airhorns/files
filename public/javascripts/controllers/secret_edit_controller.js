(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.SecretEditController = (function() {
    function SecretEditController() {
      SecretEditController.__super__.constructor.apply(this, arguments);
    }
    __extends(SecretEditController, Backbone.Controller);
    SecretEditController.prototype.initialize = function() {
      return $('#secretedit').editable({
        onSubmit: function(content) {
          return $.ajax({
            type: 'POST',
            url: "/secret_message",
            data: {
              message: content.current
            },
            success: function() {
              return FDB.notify("Saved.");
            },
            error: function() {
              return FDB.notify("Couldn't save!");
            }
          });
        }
      });
    };
    return SecretEditController;
  })();
}).call(this);
