(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  FDB.registerView('queue/index', FDB.QueueIndexView = (function() {
    function QueueIndexView() {
      QueueIndexView.__super__.constructor.apply(this, arguments);
    }
    __extends(QueueIndexView, FDB.View);
    QueueIndexView.prototype.initialize = function() {
      this.render();
      this.itemViews = {};
      this.collection.bind('add', __bind(function(model) {
        return this.addItem(model);
      }, this));
      this.collection.bind('remove', __bind(function(model) {
        return this.removeItem(model);
      }, this));
      return this.collection.each(function(model) {
        return this.addItem(model);
      });
    };
    QueueIndexView.prototype.addItem = function(model) {
      var view;
      this.itemViews[model.id] = view = new (FDB.view('queue/queue_item'))({
        model: model
      });
      view.render();
      return this.itemList.append(view.el);
    };
    QueueIndexView.prototype.removeItem = function(model) {
      return $(this.itemViews[model.id].el).remove();
    };
    QueueIndexView.prototype.render = function() {
      QueueIndexView.__super__.render.apply(this, arguments);
      return this.itemList = $('#unconfirmed_downloads', this.el);
    };
    return QueueIndexView;
  })());
}).call(this);
