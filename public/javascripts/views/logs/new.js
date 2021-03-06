(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  FDB.registerView("logs/new", FDB.NewLogView = (function() {
    function NewLogView() {
      NewLogView.__super__.constructor.apply(this, arguments);
    }
    __extends(NewLogView, FDB.View);
    NewLogView.prototype.renderable = function() {
      var attrs, v, x, _i, _len, _ref;
      attrs = NewLogView.__super__.renderable.apply(this, arguments);
      _ref = ["start", "end"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        x = _ref[_i];
        v = attrs["" + x + "_date"];
        attrs["" + x + "_date"] = jQuery.datepicker.formatDate('mm/dd/yy', v);
        attrs["" + x + "_time"] = FDB.fmt.formatTime(v);
      }
      attrs.shows = [
        {
          name: "A",
          value: 1
        }, {
          name: "C",
          value: 2
        }, {
          name: "D",
          value: 3
        }, {
          name: "E",
          value: 4
        }
      ];
      return attrs;
    };
    NewLogView.prototype._getDateTime = function(n) {
      var d, t;
      t = $.timePicker("#log_" + n + "_time").getTime();
      d = $("#log_" + n + "_date").datepicker('getDate');
      return new Date(d.getFullYear(), d.getMonth(), d.getDate(), t.getHours(), t.getMinutes());
    };
    NewLogView.prototype._setDateTime = function(time, n) {
      var x;
      x = new Date;
      x.setTime(time.valueOf());
      $.timePicker("#log_" + n + "_time").setTime(x);
      return $("#log_" + n + "_date").datepicker('setDate', time);
    };
    NewLogView.prototype.getEndDateTime = function() {
      return this._getDateTime('end');
    };
    NewLogView.prototype.getStartDateTime = function() {
      return this._getDateTime('start');
    };
    NewLogView.prototype.setEndDateTime = function(time) {
      return this._setDateTime(time, 'end');
    };
    NewLogView.prototype.setStartDateTime = function(time) {
      return this._setDateTime(time, 'start');
    };
    NewLogView.prototype._roundMs = function(x) {
      return (Math.round(x / 60000)) * 60000;
    };
    NewLogView.prototype.afterRender = function(renderable) {
      var columns, data, duration, grid, i, id, options;
      duration = this._roundMs(this.model.get('end_date') - this.model.get('start_date'));
      this.$('#log_end_date, #log_end_time').change(__bind(function(e) {
        return duration = this._roundMs(this.getEndDateTime() - this.getStartDateTime());
      }, this));
      this.$('#log_start_date, #log_start_time').change(__bind(function(e) {
        var newEnd;
        newEnd = new Date;
        newEnd.setTime(this.getStartDateTime().getTime() + duration);
        return this.setEndDateTime(newEnd);
      }, this));
      columns = [
        {
          id: "time",
          name: "Start Time",
          field: "time"
        }, {
          id: "duration",
          name: "Duration",
          field: "duration"
        }, {
          id: "artist",
          name: "Artist",
          field: "artist"
        }, {
          id: "album",
          name: "Album",
          field: "album"
        }, {
          id: "song",
          name: "Song",
          field: "song"
        }, {
          id: "category",
          name: "Category",
          field: "category"
        }, {
          id: "canadian",
          name: "Canadian",
          field: "canadian_content"
        }, {
          id: "new_release",
          name: "New Release",
          field: "new_release"
        }, {
          id: "french_vocals",
          name: "French Vocals",
          field: "french_vocals"
        }, {
          id: "request",
          name: "Request",
          field: "request"
        }
      ];
      options = {
        enableCellNavigation: true,
        enableColumnReorder: false
      };
      data = [];
      for (i = 0; i <= 100; i++) {
        data[i] = {
          time: "3:00",
          duration: "3:00",
          artist: "Artist " + i,
          album: "Album " + i,
          song: "Song " + i,
          category: false,
          canadian_content: false,
          new_release: false,
          french_vocals: false,
          request: false
        };
      }
      id = "#log_log_items_grid";
      grid = new Slick.Grid(id, data, columns, options);
      return $(id).show();
    };
    return NewLogView;
  })());
}).call(this);
