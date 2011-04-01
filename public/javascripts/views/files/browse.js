(function() {
  var suggestedType;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  suggestedType = function(extension) {
    switch (extension) {
      case "avi":
      case "mpg":
      case "mpeg":
      case "mkv":
      case "wmv":
        return "video";
      case "mp3":
      case "flac":
      case "aac":
      case "wav":
        return "audio";
      case "zip":
      case "rar":
      case "dmg":
      case "7z":
        return "archive";
      default:
        return "";
    }
  };
  FDB.registerView('files/browse', FDB.FilesBrowseView = (function() {
    function FilesBrowseView() {
      FilesBrowseView.__super__.constructor.apply(this, arguments);
    }
    __extends(FilesBrowseView, FDB.View);
    FilesBrowseView.prototype.render = function() {
      var columns, downloadLink, nameFormatter, options;
      FilesBrowseView.__super__.render.apply(this, arguments);
      options = {
        enableCellNavigation: true,
        enableColumnReorder: false,
        forceFitColumns: true
      };
      nameFormatter = __bind(function(row, cell, value, columnDef, dataContext) {
        var idx, spacer;
        spacer = "<span style='display:inline-block;height:1px;width:" + (15 * dataContext["indent"]) + "px'></span>";
        idx = this.dataView.getIdxById(dataContext.id);
        if (dataContext.type === "dir") {
          if (dataContext._collapsed) {
            return spacer + " <span class='toggle dir expand'></span>&nbsp;" + value;
          } else {
            return spacer + " <span class='toggle dir collapse'></span>&nbsp;" + value;
          }
        } else {
          return spacer + (" <span class='toggle file " + dataContext.ext + " " + (suggestedType(dataContext.ext)) + "'></span>&nbsp;") + value;
        }
      }, this);
      downloadLink = function(row, cell, value, columnDef, file) {
        if (file.type === "file") {
          return "<a class=\"download\" target=\"_blank\" href=\"" + FDB.Config.assetHost + file.id + "\">DL</a>";
        } else {
          return "";
        }
      };
      columns = [
        {
          id: "name",
          name: "Name",
          field: "name",
          formatter: nameFormatter
        }, {
          id: "size",
          name: "Size",
          field: "size"
        }, {
          id: "modified",
          name: "Date Modified",
          field: "modified"
        }, {
          id: "download",
          name: "DL",
          formatter: downloadLink
        }
      ];
      this.dataView = new Slick.Data.DataView();
      this.grid = new Slick.Grid("#browse_grid", this.dataView, columns, options);
      this.dataView.onRowCountChanged.subscribe(__bind(function(e, args) {
        this.grid.updateRowCount();
        return this.grid.render();
      }, this));
      this.dataView.onRowsChanged.subscribe(__bind(function(e, args) {
        this.grid.invalidateRows(args.rows);
        return this.grid.render();
      }, this));
      this.grid.onClick.subscribe(__bind(function(e, args) {
        var item;
        if ($(e.target).hasClass("toggle")) {
          item = this.dataView.getItem(args.row);
          if (item) {
            if (!item._collapsed) {
              item._collapsed = true;
            } else {
              item._collapsed = false;
            }
            this.dataView.updateItem(item.id, item);
          }
          e.stopImmediatePropagation();
          return this.trigger("rowClicked", item, args, e);
        }
      }, this));
      return true;
    };
    return FilesBrowseView;
  })());
}).call(this);
