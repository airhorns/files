suggestedType = (extension) ->
  switch extension
    when "avi", "mpg", "mpeg", "mkv", "wmv"
      "video"
    when "mp3", "flac", "aac", "wav"
      "audio"
    when "zip", "rar", "dmg", "7z"
      "archive"
    else ""

FDB.registerView 'files/browse',
class FDB.FilesBrowseView extends FDB.View
  render: ->
    super

    options =
      enableCellNavigation: true
      enableColumnReorder: false
      forceFitColumns: true

    nameFormatter = (row, cell, value, columnDef, dataContext) =>
      s = "<span style='display:inline-block;height:1px;width:" + (15 * dataContext["indent"]) + "px'></span>"
      idx = @dataView.getIdxById(dataContext.id)
      if (dataContext.type == "dir")
        if (dataContext._collapsed)
          s += " <span class='icon toggle dir expand'></span>&nbsp;"
        else
          s += " <span class='icon toggle dir collapse'></span>&nbsp;"
          
      else
        s += " <span class='icon file #{dataContext.ext} #{suggestedType(dataContext.ext)}'></span>&nbsp;"

      s += "<span class='#{if dataContext.downloaded then "" else "un"}downloaded'>#{value}</span>"
      if dataContext.toggling
        s += " <img src=\"/images/spinner.gif\">"
      
      s

    downloadLink = (row, cell, value, columnDef, file) ->
      if file.type == "file"
        "<a class=\"download\" target=\"_blank\" href=\"#{FDB.Config.assetHost}#{file.id}\">DL</a>"
      else
        ""

    markAsDownloadedLink = (row, cell, value, columnDef, file) ->
      "<a class='toggle_downloaded' href='#'>#{if file.downloaded then "U" else ""}MK</a>"

    columns = [
      {id:"name", name:"Name", field:"name", formatter: nameFormatter},
      {id:"size", name:"Size", field:"size"},
      {id:"modified", name:"Date Modified", field:"modified"},
      {id:"download", name:"DL", formatter: downloadLink},
      {id:"mark", name:"MK", formatter: markAsDownloadedLink},
    ]

    @grid = new Slick.Grid("#browse_grid", @dataView, columns, options)
    # wire up model events to drive the grid
    @dataView.onRowCountChanged.subscribe (e, args) =>
      @grid.updateRowCount()
      @grid.render()

    @dataView.onRowsChanged.subscribe (e,args) =>
      @grid.invalidateRows(args.rows)
      @grid.render()

    @grid.onClick.subscribe (e,args) =>
      $$ = $(e.target)
      item = @dataView.getItem(args.row)
      if item
        if $$.hasClass("toggle")
          item._collapsed = !item._collapsed
          @dataView.updateItem(item.id, item)
          this.trigger("rowToggled", item, args, e)
        else if $$.hasClass("toggle_downloaded")
          this.trigger("toggleDownloadedClicked", item, args, e)

      e.stopImmediatePropagation()
      e.preventDefault()
      return false

    true

