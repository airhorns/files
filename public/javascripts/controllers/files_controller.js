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
      this.updateLog = __bind(this.updateLog, this);;
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
        this.view.render();
        if (this.root.fetched) {
          this.generateData();
        } else {
          this.root.bind("change", this.generateData);
        }
        return this.view.bind("rowClicked", this.updateLog);
      }
    };
    FilesController.prototype.generateData = function() {
      this.log = this.root.toDataView();
      return this.view.dataView.setItems(this.log);
    };
    FilesController.prototype.updateLog = function(item, args, e) {
      var insert, toggle;
      insert = __bind(function() {
        var i, indexOfOpened, items, newItem;
        this.view.dataView.beginUpdate();
        items = item.obj.subDataView(item.id, item.indent + 1);
        indexOfOpened = this.view.dataView.getIdxById(item.id);
        for (i in items) {
          newItem = items[i];
          this.view.dataView.insertItem(indexOfOpened + 1, items[items.length - 1 - i]);
        }
        return this.view.dataView.endUpdate();
      }, this);
      toggle = __bind(function() {}, this);
      if (!item.obj.fetched) {
        return item.obj.fetch({
          success: function() {
            return insert() && toggle();
          }
        });
      } else {
        return toggle();
      }
    };
    return FilesController;
  })();
}).call(this);
