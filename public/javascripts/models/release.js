(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.Release = (function() {
    function Release() {
      Release.__super__.constructor.apply(this, arguments);
    }
    __extends(Release, Backbone.Model);
    Release.prototype.initialize = function(options) {
      this.id || (this.id = this.get('_id'));
      this.downloadable = options.downloadable;
      this.parent_id = this.downloadable.get('_id');
      return this.url = "/api/1/downloadables/" + this.parent_id + "/releases/" + this.id;
    };
    return Release;
  })();
  FDB.ReleaseCollection = (function() {
    function ReleaseCollection() {
      ReleaseCollection.__super__.constructor.apply(this, arguments);
    }
    __extends(ReleaseCollection, Backbone.Collection);
    ReleaseCollection.prototype.model = FDB.Release;
    ReleaseCollection.prototype.initialize = function(models, options) {
      this.parent_id = options.downloadable.get("_id");
      this.url = "/api/1/downloadables/" + this.parent_id + "/releases";
      if (options.unconfirmed) {
        return this.url += "/unconfirmed";
      }
    };
    return ReleaseCollection;
  })();
}).call(this);
