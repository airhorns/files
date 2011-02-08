(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  LDB.registerView("logs/new", LDB.NewLogView = (function() {
    function NewLogView() {
      NewLogView.__super__.constructor.apply(this, arguments);
    }
    __extends(NewLogView, LDB.View);
    NewLogView.prototype.renderable = function() {
      var log;
      log = NewLogView.__super__.renderable.apply(this, arguments);
      log.shows = [
        {
          name: "A",
          value: 1
        }, {
          name: "C",
          value: 2
        }, {
          name: "D",
          value: 3
        }, {
          name: "E",
          value: 4
        }
      ];
      return log;
    };
    return NewLogView;
  })());
}).call(this);
