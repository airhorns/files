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
      var exts, row, segments;
      segments = this.get("id").split("/");
      exts = this.get("id").split(".");
      return row = {
        id: this.get("id"),
        type: "file",
        ext: exts[exts.length - 1],
        name: segments[segments.length - 1],
        modified: this.get("modified"),
        size: this.get("size")
      };
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
