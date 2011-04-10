(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  FDB.FilesController = (function() {
    function FilesController() {
      this.toggleDownloaded = __bind(this.toggleDownloaded, this);;
      this.toggleRow = __bind(this.toggleRow, this);;
      this.generateData = __bind(this.generateData, this);;      FilesController.__super__.constructor.apply(this, arguments);
    }
    __extends(FilesController, Backbone.Controller);
    FilesController.prototype.initialize = function() {
      this.root = new FDB.Directory({
        id: "/"
      });
      return this.root.fetch({
        success: function() {
          return this.fetched = true;
        }
      });
    };
    FilesController.prototype.views = {};
    FilesController.prototype.routes = {
      '/files': 'browse',
      '/files/*path': 'browse',
      '/files/*path.:ext': 'browse'
    };
    FilesController.prototype.browse = function() {
      if (this.view == null) {
        this.view = new (FDB.view('files/browse'));
        FDB.rootView.panel('files').append(this.view.el);
        this.dataView = new Slick.Data.DataView();
        this.view.dataView = this.dataView;
        this.view.render();
        if (this.root.fetched) {
          this.generateData();
        } else {
          this.root.bind("change", this.generateData);
        }
        this.view.bind("rowToggled", this.toggleRow);
        this.view.bind("toggleDownloadedClicked", this.toggleDownloaded);
        return $('.mark_all_as_downloaded', this.view.el).click(__bind(function(e) {
          this.toggleDownloaded(this.rootItem);
          return e.preventDefault();
        }, this));
      }
    };
    FilesController.prototype.generateData = function() {
      var item, log, _i, _len;
      this.root.unbind("change", this.generateData);
      this.view.dataView = this.dataView;
      log = this.root.toDataView();
      for (_i = 0, _len = log.length; _i < _len; _i++) {
        item = log[_i];
        if (item.type === "dir") {
          item._collapsed = true;
        }
        this.observeFileSystemObject(item.obj);
      }
      this.rootItem = log[0];
      this.rootItem._collapsed = false;
      this.dataView.beginUpdate();
      this.dataView.setItems(log);
      this.dataView.setFilter(__bind(function(item) {
        var parent;
        if (item.parent != null) {
          parent = this.dataView.getItemById(item.parent);
          while (parent) {
            if (parent._collapsed) {
              return false;
            }
            parent = this.dataView.getItemById(parent.parent);
          }
        } else {
          return false;
        }
        return true;
      }, this));
      return this.dataView.endUpdate();
    };
    FilesController.prototype.toggleRow = function(item, args, e) {
      console.log("Row clicked: " + item.id);
      if (!item.obj.fetched) {
        return item.obj.fetch({
          success: __bind(function() {
            this.insertSubordinateRows(item);
            return console.log("After insertion, item.collapsed is " + item._collapsed);
          }, this),
          error: function() {
            return FDB.notify("Transport error. Ensure you are connected to the internet, and refresh the page.");
          }
        });
      } else {
        return console.log("Already had data, item.collapsed is " + item._collapsed);
      }
    };
    FilesController.prototype.toggleDownloaded = function(item, args, e) {
      var allBelowDownloaded, fix, i, length, parent, sub, _i, _len, _ref;
      this.dataView.beginUpdate();
      item.obj.set({
        downloaded: !item.obj.get('downloaded')
      });
      item.obj.save();
      length = this.dataView.getLength();
      i = this.dataView.getIdxById(item.id);
      fix = item.obj.get('downloaded');
      _ref = this.subordinatesOf(item);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        sub = _ref[_i];
        sub.obj.set({
          downloaded: fix
        });
      }
      if (item.parent != null) {
        parent = this.dataView.getItemById(item.parent);
      }
      while (parent != null) {
        allBelowDownloaded = _(this.childrenOf(parent)).all(function(x) {
          return x.downloaded === true;
        });
        parent.obj.set({
          downloaded: allBelowDownloaded
        });
        parent = this.dataView.getItemById(parent.parent);
      }
      return this.dataView.endUpdate();
    };
    FilesController.prototype.insertSubordinateRows = function(item) {
      var i, indexOfOpened, items, newItem, _ref;
      console.log("Inserting fetched rows");
      indexOfOpened = this.dataView.getIdxById(item.id);
      items = item.obj.subDataView(item.id);
      this.dataView.beginUpdate();
      _ref = items.reverse();
      for (i in _ref) {
        newItem = _ref[i];
        if (newItem.type === "dir") {
          newItem._collapsed = true;
        }
        this.observeFileSystemObject(newItem.obj);
        console.log(newItem);
        this.dataView.insertItem(indexOfOpened + 1, newItem);
      }
      return this.dataView.endUpdate();
    };
    FilesController.prototype.observeFileSystemObject = function(model) {
      return model.bind('change', __bind(function() {
        return this.dataView.updateItem(model.id, _.extend({}, this.view.dataView.getItemById(model.id), model.toDataRow()));
      }, this));
    };
    FilesController.prototype.subordinatesOf = function(item) {
      var i, length, sub, subs;
      length = this.dataView.getLength();
      i = this.dataView.getIdxById(item.id);
      subs = [];
      while (++i < length) {
        sub = this.dataView.getItemByIdx(i);
        if (sub.indent <= item.indent) {
          break;
        }
        subs.push(sub);
      }
      return subs;
    };
    FilesController.prototype.childrenOf = function(item) {
      var targetIndent;
      targetIndent = item.indent + 1;
      return _(this.subordinatesOf(item)).select(function(x) {
        return x.indent === targetIndent;
      });
    };
    return FilesController;
  })();
}).call(this);
