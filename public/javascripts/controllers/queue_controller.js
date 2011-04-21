(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.QueueController = (function() {
    function QueueController() {
      QueueController.__super__.constructor.apply(this, arguments);
    }
    __extends(QueueController, Backbone.Controller);
    QueueController.prototype.views = {};
    QueueController.prototype.routes = {
      '/queue': 'index',
      '/queue/:id': 'show'
    };
    QueueController.prototype.initialize = function() {
      this.unconfirmed_collection = new FDB.DownloadableCollection();
      return this.unconfirmed_collection.url = "/api/1/downloadables/unconfirmed";
    };
    QueueController.prototype.index = function() {
      if (this.views['index'] == null) {
        this.unconfirmed_collection.fetch({
          add: true
        });
        this.views['index'] = new (FDB.view('queue/index'))({
          collection: this.unconfirmed_collection
        });
        return FDB.rootView.panel('queue').append(this.views['index'].el);
      }
    };
    return QueueController;
  })();
}).call(this);
