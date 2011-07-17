(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.registerView('queue/queue_item', FDB.QueueItemView = (function() {
    __extends(QueueItemView, FDB.View);
    function QueueItemView() {
      QueueItemView.__super__.constructor.apply(this, arguments);
    }
    QueueItemView.prototype.tagName = 'div';
    QueueItemView.prototype.className = 'queue_item';
    QueueItemView.prototype.renderable = function() {
      return _.extend(this.model.toJSON(), {
        unconfirmed_releases: this.model.unconfirmed_releases.toJSON()
      });
    };
    QueueItemView.prototype.render = function() {
      QueueItemView.__super__.render.call(this);
      return $('button', this.el).button();
    };
    return QueueItemView;
  })());
}).call(this);
