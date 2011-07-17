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
    __extends(Directory, Backbone.Model);
    function Directory() {
      Directory.__super__.constructor.apply(this, arguments);
    }
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
          delete parsed_resp['files'];
          model.files = new FDB.FileCollection(_(files).chain().map(normalize_resp).map(function(x) {
            return new FDB.File(x);
          }).value());
          model._changed = true;
        }
        if (directories = parsed_resp['directories']) {
          delete parsed_resp['directories'];
          model.directories = new FDB.DirectoryCollection(_(directories).chain().map(normalize_resp).map(function(x) {
            return new FDB.Directory(x);
          }).value());
          model._changed = true;
        }
        model.fetched = true;
        if (!model.set(parsed_resp, options)) {
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
    Directory.prototype.toDataView = function(parent_id) {
      var row, tree;
      if (parent_id == null) {
        parent_id = null;
      }
      tree = [];
      row = _.extend(this.toDataRow(), {
        parent: parent_id
      });
      tree.push(row);
      tree = tree.concat(this.subDataView(row.id));
      return tree;
    };
    Directory.prototype.subDataView = function(parent_row_id) {
      var tree;
      if (parent_row_id == null) {
        parent_row_id = this.toDataRow().id;
      }
      tree = [];
      if (this.directories != null) {
        this.directories.each(function(dir) {
          return tree = tree.concat(dir.toDataView(parent_row_id));
        });
      }
      if (this.files != null) {
        this.files.each(function(file) {
          file = file.toDataRow();
          return tree.push(_.extend(file, {
            parent: parent_row_id
          }));
        });
      }
      return tree;
    };
    Directory.prototype.toDataRow = function() {
      var row;
      return row = _.extend(this.toJSON(), {
        type: "dir",
        name: this.name(),
        obj: this,
        indent: this.get("id").split("/").length - 3
      });
    };
    Directory.prototype.name = function() {
      var s, segments;
      segments = this.get("id").split("/");
      s = segments[segments.length - 2];
      if (this.fetched && this.directories.length === 0 && this.files.length === 0) {
        s += " (empty)";
      }
      return s;
    };
    return Directory;
  })();
  FDB.DirectoryCollection = (function() {
    __extends(DirectoryCollection, Backbone.Collection);
    function DirectoryCollection() {
      DirectoryCollection.__super__.constructor.apply(this, arguments);
    }
    DirectoryCollection.prototype.model = FDB.Directory;
    return DirectoryCollection;
  })();
}).call(this);
