(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  LDB.registerView("logs/new", LDB.NewLogView = (function() {
    function NewLogView() {
      NewLogView.__super__.constructor.apply(this, arguments);
    }
    __extends(NewLogView, LDB.View);
    NewLogView.prototype.renderable = function() {
      var attrs, v, x, _i, _len, _ref;
      attrs = NewLogView.__super__.renderable.apply(this, arguments);
      _ref = ["start", "end"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        x = _ref[_i];
        v = attrs["" + x + "_date"];
        attrs["" + x + "_date"] = jQuery.datepicker.formatDate('mm/dd/yy', v);
        attrs["" + x + "_time"] = LDB.fmt.formatTime(v);
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
      $.timePicker("#log_" + n + "_time").setTime(time);
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
    NewLogView.prototype.afterRender = function(renderable) {
      var duration;
      duration = this.model.get('end_date') - this.model.get('start_date');
      this.$('#log_end_date').change(__bind(function(e) {
        return duration = this.getEndDateTime() - this.getStartDateTime();
      }, this));
      return this.$('#log_start_date').change(__bind(function(e) {
        var newEnd;
        newEnd = new Date;
        newEnd.setTime(this.getStartDateTime().getTime() + duration);
        return this.setEndDateTime(newEnd);
      }, this));
    };
    return NewLogView;
  })());
}).call(this);
