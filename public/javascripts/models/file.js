(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.File = (function() {
    function File() {
      File.__super__.constructor.apply(this, arguments);
    }
    __extends(File, Backbone.Model);
    File.prototype.initialize = function() {
      return this.url = "/api/1/files" + this.id;
    };
    File.prototype.toDataRow = function() {
      var depth, exts, row, segments;
      segments = this.get("id").split("/");
      depth = segments.length - 1;
      exts = this.get("id").split(".");
      return row = _.extend(this.toJSON(), {
        type: "file",
        ext: exts[exts.length - 1],
        name: segments[depth],
        obj: this,
        indent: depth - 1
      });
    };
    return File;
  })();
  FDB.FileCollection = (function() {
    function FileCollection() {
      FileCollection.__super__.constructor.apply(this, arguments);
    }
    __extends(FileCollection, Backbone.Collection);
    return FileCollection;
  })();
}).call(this);
