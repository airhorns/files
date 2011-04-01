class FDB.FilesController extends Backbone.Controller
  initialize: ->
    @root = new FDB.Directory({id:"/"})
    @root.fetch
      success: -> @fetched = true
  views: {}
  routes:
    '/files': 'browse'
    '/files/*path': 'browse'
    '/files/*path.:ext': 'browse'

  browse: ->
    unless @view?
      # Init view and attach to panel.
      @view = new (FDB.view('files/browse'))
      FDB.rootView.panel('files').append @view.el

      @dataView = new Slick.Data.DataView()
      @view.dataView = @dataView
      @view.render()

      # Generate the data to begin with
      if @root.fetched
        this.generateData()
      else
        @root.bind "change", this.generateData

      @view.bind "rowToggled", this.toggleRow
      @view.bind "toggleDownloadedClicked", this.toggleDownloaded
      $('.mark_all_as_downloaded', @view.el).click => this.toggleDownloaded(@root)

  # Performs the first generation of the tree
  generateData: () =>
    @view.dataView = @dataView
    # Get the flattened representation of the tree
    log = @root.toDataView()
    for item in log
      item._collapsed = true if item.type == "dir"
      this.observeFileSystemObject(item.obj)

    # Add the items to the dataview
    @dataView.beginUpdate()
    @dataView.setItems(log)
    @dataView.setFilter (item) =>
      # Parent tree traversal
      if item.parent != null
        parent = @dataView.getItemById(item.parent)
        raise "Weirdness." if parent == item
        while parent
          return false if parent._collapsed
          parent = @dataView.getItemById(parent.parent)

      return true

    @dataView.endUpdate()

  # Adds a newly toggled dir to the tree (well, into the log)
  toggleRow: (item, args, e) =>
    console.log "Row clicked: #{item.id}"

    unless item.obj.fetched
      item.obj.fetch
        success: =>
          this.insertSubordinateRows(item)
          console.log "After insertion, item.collapsed is #{item._collapsed}"
        error: ->
          FDB.notify("Transport error. Ensure you are connected to the internet, and refresh the page.")
    else
      console.log "Already had data, item.collapsed is #{item._collapsed}"
      #@dataView.refresh()

  toggleDownloaded: (item, args, e) =>
    @dataView.beginUpdate()
    item.obj.set
      downloaded: ! item.obj.get('downloaded')
    item.obj.save()

    # Loop over subordinates, setting them to the same. This is also done on the backend.
    length = @dataView.getLength()
    i = @dataView.getIdxById(item.id)
    fix = item.obj.get('downloaded')
    for sub in this.subordinatesOf(item)
      sub.obj.set
        downloaded: fix

    # Loop over parents, checking to see if their state has changed
    parent = @dataView.getItemById(item.parent)
    while parent?
      allBelowDownloaded = _(this.childrenOf(parent)).all((x) -> x.downloaded == true)
      parent.obj.set
        downloaded: allBelowDownloaded
      parent = @dataView.getItemById(parent.parent)
    
    @dataView.endUpdate()

  insertSubordinateRows: (item) ->
    console.log "Inserting fetched rows"
    indexOfOpened = @dataView.getIdxById(item.id)
    # New items for insertion
    items = item.obj.subDataView(item.id)
    @dataView.beginUpdate()
    for i, newItem of items.reverse()
      newItem._collapsed = true if newItem.type == "dir"
      this.observeFileSystemObject(newItem.obj)
      console.log(newItem)
      @dataView.insertItem(indexOfOpened+1, newItem) # Add all new items (in reverse order)
    @dataView.endUpdate()

  observeFileSystemObject: (model) ->
    model.bind 'change', =>
      @dataView.updateItem(model.id, _.extend({}, @view.dataView.getItemById(model.id), model.toDataRow()))

  subordinatesOf: (item) ->
    length = @dataView.getLength()
    i = @dataView.getIdxById(item.id)
    subs = []
    while ++i < length
      sub = @dataView.getItemByIdx(i)
      break if sub.indent <= item.indent # Loop is over if we've found an item with the same parent as this, ie a sibling, not a child
      subs.push sub
    subs

  childrenOf: (item) ->
    targetIndent = item.indent + 1
    _(this.subordinatesOf(item)).select((x) -> x.indent == targetIndent)
