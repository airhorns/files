(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.Downloadable = (function() {
    function Downloadable() {
      Downloadable.__super__.constructor.apply(this, arguments);
    }
    __extends(Downloadable, Backbone.Model);
    Downloadable.prototype.initialize = function() {
      var extras;
      this.id || (this.id = this.get('_id'));
      this.url = "/api/1/downloadable/" + this.id;
      extras = {
        downloadable: this
      };
      this.releases = new FDB.ReleaseCollection(_(this.get('releases')).map(function(x) {
        return _.extend(x, extras);
      }), extras);
      return this.unconfirmed_releases = new FDB.ReleaseCollection(this.releases.select(function(x) {
        return x.get('confirmed') === false;
      }), extras);
    };
    return Downloadable;
  })();
  FDB.DownloadableCollection = (function() {
    function DownloadableCollection() {
      DownloadableCollection.__super__.constructor.apply(this, arguments);
    }
    __extends(DownloadableCollection, Backbone.Collection);
    DownloadableCollection.prototype.model = FDB.Downloadable;
    DownloadableCollection.prototype.url = "/api/1/downloadables";
    return DownloadableCollection;
  })();
}).call(this);
