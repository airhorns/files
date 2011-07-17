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
    __extends(FilesBrowseView, FDB.View);
    function FilesBrowseView() {
      FilesBrowseView.__super__.constructor.apply(this, arguments);
    }
    FilesBrowseView.prototype.render = function() {
      var columns, downloadLink, markAsDownloadedLink, nameFormatter, options;
      FilesBrowseView.__super__.render.apply(this, arguments);
      options = {
        enableCellNavigation: true,
        enableColumnReorder: false,
        forceFitColumns: true
      };
      nameFormatter = __bind(function(row, cell, value, columnDef, dataContext) {
        var idx, s;
        s = "<span style='display:inline-block;height:1px;width:" + (15 * dataContext["indent"]) + "px'></span>";
        idx = this.dataView.getIdxById(dataContext.id);
        if (dataContext.type === "dir") {
          if (dataContext._collapsed) {
            s += " <span class='icon toggle dir expand'></span>&nbsp;";
          } else {
            s += " <span class='icon toggle dir collapse'></span>&nbsp;";
          }
        } else {
          s += " <span class='icon file " + dataContext.ext + " " + (suggestedType(dataContext.ext)) + "'></span>&nbsp;";
        }
        s += "<span class='" + (dataContext.downloaded ? "" : "un") + "downloaded'>" + value + "</span>";
        if (dataContext.toggling) {
          s += " <img src=\"/images/spinner.gif\">";
        }
        return s;
      }, this);
      downloadLink = function(row, cell, value, columnDef, file) {
        if (file.type === "file") {
          return "<a class=\"download\" target=\"_blank\" href=\"" + FDB.Config.assetHost + file.id + "\">DL</a>";
        } else {
          return "";
        }
      };
      markAsDownloadedLink = function(row, cell, value, columnDef, file) {
        return "<a class='toggle_downloaded' href='#'>" + (file.downloaded ? "U" : "") + "MK</a>";
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
        }, {
          id: "mark",
          name: "MK",
          formatter: markAsDownloadedLink
        }
      ];
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
        var $$, item;
        $$ = $(e.target);
        item = this.dataView.getItem(args.row);
        if (item) {
          if ($$.hasClass("toggle")) {
            item._collapsed = !item._collapsed;
            this.dataView.updateItem(item.id, item);
            this.trigger("rowToggled", item, args, e);
          } else if ($$.hasClass("toggle_downloaded")) {
            this.trigger("toggleDownloadedClicked", item, args, e);
          }
        }
        e.stopImmediatePropagation();
        e.preventDefault();
        return false;
      }, this));
      return true;
    };
    return FilesBrowseView;
  })());
}).call(this);
