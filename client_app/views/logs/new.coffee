LDB.registerView "logs/new", class LDB.NewLogView extends LDB.View
  renderable: ->
    attrs = super # get the attributes from the log

    # Massage the start and end datetimes into stuff for the view
    for x in ["start", "end"]
      v = attrs["#{x}_date"]
      attrs["#{x}_date"] = jQuery.datepicker.formatDate('mm/dd/yy', v)
      attrs["#{x}_time"] = LDB.fmt.formatTime(v) # defined in public/lib/jquery.timepicker.js
    
    # Add the shows list for the select. This is temporary, probably should become an autocomplete
    attrs.shows = [{name:"A", value:1},{name:"C",value:2},{name:"D",value:3},{name:"E", value:4}]
    attrs

  _getDateTime: (n) ->
    t = $.timePicker("#log_#{n}_time").getTime()
    d = $("#log_#{n}_date").datepicker('getDate')
    return new Date(d.getFullYear(), d.getMonth(),d.getDate(), t.getHours(), t.getMinutes())

  _setDateTime: (time, n) ->
    $.timePicker("#log_#{n}_time").setTime(time)
    $("#log_#{n}_date").datepicker('setDate', time)
  
  # I want to curry these but I don't know what to bind them to
  getEndDateTime: ->
    this._getDateTime('end')
  getStartDateTime: ->
    this._getDateTime('start')
  setEndDateTime: (time) ->
    this._setDateTime(time, 'end')
  setStartDateTime: (time) ->
    this._setDateTime(time, 'start')

  afterRender: (renderable) ->
    # Define the Google Calendar like behaviour of changing the end date if the user changes
    # the start date
    duration = this.model.get('end_date') - this.model.get('start_date') # Initial duration
    this.$('#log_end_date').change (e) =>
      duration = this.getEndDateTime() - this.getStartDateTime()

    this.$('#log_start_date').change (e) =>
      newEnd = new Date
      newEnd.setTime(this.getStartDateTime().getTime() + duration)
      this.setEndDateTime(newEnd)
