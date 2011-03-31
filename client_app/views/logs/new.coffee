FDB.registerView "logs/new", class FDB.NewLogView extends FDB.View
  renderable: ->
    attrs = super # get the attributes from the log

    # Massage the start and end datetimes into stuff for the view
    for x in ["start", "end"]
      v = attrs["#{x}_date"]
      attrs["#{x}_date"] = jQuery.datepicker.formatDate('mm/dd/yy', v)
      attrs["#{x}_time"] = FDB.fmt.formatTime(v) # defined in public/lib/jquery.timepicker.js

    # Add the shows list for the select. This is temporary, probably should become an autocomplete
    attrs.shows = [{name:"A", value:1},{name:"C",value:2},{name:"D",value:3},{name:"E", value:4}]
    attrs

  _getDateTime: (n) ->
    t = $.timePicker("#log_#{n}_time").getTime()
    d = $("#log_#{n}_date").datepicker('getDate')
    return new Date(d.getFullYear(), d.getMonth(),d.getDate(), t.getHours(), t.getMinutes())

  _setDateTime: (time, n) ->
    # Timepicker modifies the time it gets when you set it! Clone the object to keep the actual
    # date around. Goddamnit.
    x = new Date
    x.setTime(time.valueOf())
    $.timePicker("#log_#{n}_time").setTime(x)
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
  _roundMs: (x) ->
    (Math.round x/60000)*60000

  afterRender: (renderable) ->

    # Define the Google Calendar like behaviour of changing the end date if the user changes
    # the start date
    duration = this._roundMs(this.model.get('end_date') - this.model.get('start_date')) # Initial duration
    this.$('#log_end_date, #log_end_time').change (e) =>
      duration = this._roundMs(this.getEndDateTime() - this.getStartDateTime())

    this.$('#log_start_date, #log_start_time').change (e) =>
      newEnd = new Date
      newEnd.setTime(this.getStartDateTime().getTime() + duration)
      this.setEndDateTime(newEnd)

    # Setup THE GRID
    columns = [
      {id:"time", name:"Start Time", field:"time"}
      {id:"duration", name:"Duration", field:"duration"}
      {id:"artist", name:"Artist", field:"artist"}
      {id:"album", name:"Album", field:"album"}
      {id:"song", name:"Song", field:"song"}
      {id:"category", name:"Category", field:"category"}
      {id:"canadian", name:"Canadian", field:"canadian_content"}
      {id:"new_release", name:"New Release", field:"new_release"}
      {id:"french_vocals", name:"French Vocals", field:"french_vocals"}
      {id:"request", name:"Request", field:"request"}
    ]

    options =
      enableCellNavigation: true
      enableColumnReorder: false

    data = []
    for i in [0..100]
      data[i] =
        time: "3:00"
        duration: "3:00"
        artist: "Artist #{i}"
        album: "Album #{i}"
        song: "Song #{i}"
        category: false
        canadian_content: false
        new_release: false
        french_vocals: false
        request: false

    id = "#log_log_items_grid"
    grid = new Slick.Grid(id, data, columns, options)
    $(id).show()
