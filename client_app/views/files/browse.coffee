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
      spacer = "<span style='display:inline-block;height:1px;width:" + (15 * dataContext["indent"]) + "px'></span>"
      idx = @dataView.getIdxById(dataContext.id)
      if (dataContext.type == "dir")
        if (dataContext._collapsed)
          return spacer + " <span class='toggle dir expand'></span>&nbsp;" + value
        else
          return spacer + " <span class='toggle dir collapse'></span>&nbsp;" + value
      else
        return spacer + " <span class='toggle file #{dataContext.ext} #{suggestedType(dataContext.ext)}'></span>&nbsp;" + value
 
    columns = [
      {id:"name", name:"Name", field:"name", formatter: nameFormatter},
      {id:"size", name:"Size", field:"size"},
      {id:"modified", name:"Date Modified", field:"modified"},
      {id:"actions", name:"Actions", field:"actions"},
    ]

    @dataView = new Slick.Data.DataView()
    @grid = new Slick.Grid("#browse_grid", @dataView, columns, options)
    # wire up model events to drive the grid
    @dataView.onRowCountChanged.subscribe (e, args) =>
      @grid.updateRowCount()
      @grid.render()

    @dataView.onRowsChanged.subscribe (e,args) =>
      @grid.invalidateRows(args.rows)
      @grid.render()
    
    @grid.onClick.subscribe (e,args) =>
      if $(e.target).hasClass("toggle")
        item = @dataView.getItem(args.row)
        if item
          if !item._collapsed
            item._collapsed = true
          else
            item._collapsed = false
          @dataView.updateItem(item.id, item)
        e.stopImmediatePropagation()
        this.trigger("rowClicked", item, args, e)
    true

