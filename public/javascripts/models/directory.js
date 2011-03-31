(function() {
  var wrapError;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  wrapError = function(onError, model, options) {
    return function(resp) {
      if (onError) {
        return onError(model, resp, options);
      } else {
        return model.trigger('error', model, resp, options);
      }
    };
  };
  FDB.Directory = (function() {
    function Directory() {
      Directory.__super__.constructor.apply(this, arguments);
    }
    __extends(Directory, Backbone.Model);
    Directory.prototype.initialize = function() {
      return this.url = "/api/1/files" + this.id;
    };
    Directory.prototype.fetch = function(options) {
      var model, success;
      options || (options = {});
      model = this;
      success = options.success;
      options.success = function(resp) {
        var directories, files, normalize_resp, parsed_resp;
        parsed_resp = model.parse(resp);
        normalize_resp = function(x) {
          x.id = x.path;
          return x;
        };
        if (files = parsed_resp['files']) {
          model.files = new FDB.FileCollection(_(files).chain().map(normalize_resp).map(function(x) {
            return new FDB.File(x);
          }).value());
        }
        if (directories = parsed_resp['directories']) {
          model.directories = new FDB.DirectoryCollection(_(directories).chain().map(normalize_resp).map(function(x) {
            return new FDB.Directory(x);
          }).value());
        }
        if (!model.set(model.parse(resp), options)) {
          return false;
        }
        if (success) {
          return success(model, resp);
        }
      };
      options.error = wrapError(options.error, model, options);
      (this.sync || Backbone.sync)('read', this, options);
      return this;
    };
    Directory.prototype.toDataView = function(parent_id, indent) {
      var row, tree;
      if (parent_id == null) {
        parent_id = null;
      }
      if (indent == null) {
        indent = 0;
      }
      tree = [];
      row = _.extend(this.toDataRow(), {
        indent: indent,
        obj: this,
        parent: parent_id
      });
      if (parent_id != null) {
        tree.push(row);
      }
      tree = tree.concat(this.subDataView(row.id, indent + 1));
      return tree;
    };
    Directory.prototype.subDataView = function(parent_row_id, indent) {
      var tree;
      if (parent_row_id == null) {
        parent_row_id = this.toDataRow().id;
      }
      tree = [];
      if (this.directories != null) {
        this.directories.each(function(dir) {
          return tree = tree.concat(dir.toDataView(parent_row_id, indent));
        });
      }
      if (this.files != null) {
        this.files.each(function(file) {
          file = file.toDataRow();
          return tree.push(_.extend(file, {
            parent: parent_row_id,
            indent: indent
          }));
        });
      }
      return tree;
    };
    Directory.prototype.toDataRow = function() {
      var row, segments;
      segments = this.get("id").split("/");
      return row = {
        id: this.get("id"),
        type: "dir",
        _collapsed: true,
        name: segments[segments.length - 1],
        modified: this.get("modified"),
        size: this.get("size")
      };
    };
    return Directory;
  })();
  FDB.DirectoryCollection = (function() {
    function DirectoryCollection() {
      DirectoryCollection.__super__.constructor.apply(this, arguments);
    }
    __extends(DirectoryCollection, Backbone.Collection);
    DirectoryCollection.prototype.model = FDB.Directory;
    return DirectoryCollection;
  })();
}).call(this);
