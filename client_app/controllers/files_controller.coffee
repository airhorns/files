class FDB.FilesController extends Backbone.Controller
  initialize: ->
    @root = new FDB.Directory({id:"/"})

  views: {}
  routes:
    '/files': 'browse'
    '/files/*path': 'browse'
    '/files/*path.:ext': 'browse'

  browse: ->
    unless @root.fetched
      @root.fetch
        success: -> @fetched = true

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
      $('.mark_all_as_downloaded', @view.el).click (e) =>
        this.toggleDownloaded(@rootItem)
        e.preventDefault()

  # Performs the first generation of the tree
  generateData: () =>
    @root.unbind "change", this.generateData
    @view.dataView = @dataView

    # Get the flattened representation of the tree
    log = @root.toDataView()
    for item in log
      item._collapsed = true if item.type == "dir"
      this.observeFileSystemObject(item.obj)

    # Store a reference to the root item for later, and expand it by default
    @rootItem = log[0]
    @rootItem._collapsed = false

    # Add the items to the dataview
    @dataView.beginUpdate()
    @dataView.setItems(log)
    @dataView.setFilter (item) =>
      # Parent tree traversal
      if item.parent?
        parent = @dataView.getItemById(item.parent)
        while parent
          return false if parent._collapsed
          parent = @dataView.getItemById(parent.parent)
      else
        return false # dont show the root
      
      return true

    @dataView.endUpdate()

  # Adds a newly toggled dir to the tree (well, into the log)
  toggleRow: (item, args, e) =>
    return if item.toggling # Ensure that the fetch call isn't made twice
    unless item.obj.fetched
      item.toggling = true # Mark the item as toggling so the view can render the spinner
      @dataView.updateItem(item.id, item)
      item.obj.fetch
        success: =>
          # Unmark the item for toggling, but make sure that we get an updated item first
          # as other code might have changed properties (somehow, (empty) gets added before this gets called)
          item = @dataView.getItemById(item.id)
          item.toggling = false
          @dataView.updateItem(item.id, item)
          this.insertSubordinateRows(item)
        error: ->
          FDB.notify("Transport error. Ensure you are connected to the internet, and refresh the page.")

  # Run when a mark button is hit
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
    parent = @dataView.getItemById(item.parent) if item.parent?
    while parent?
      allBelowDownloaded = _(this.childrenOf(parent)).all((x) -> x.downloaded == true)
      parent.obj.set
        downloaded: allBelowDownloaded
      parent = @dataView.getItemById(parent.parent)
    
    @dataView.endUpdate()

  # Called when a row's children weren't fetched before, and they have just been fetched and need to 
  # be inserted into the dataview.
  insertSubordinateRows: (item) ->
    indexOfOpened = @dataView.getIdxById(item.id)
    # New items for insertion
    items = item.obj.subDataView(item.id)
    @dataView.beginUpdate()
    for i, newItem of items.reverse()
      newItem._collapsed = true if newItem.type == "dir"
      this.observeFileSystemObject(newItem.obj)
      @dataView.insertItem(indexOfOpened+1, newItem) # Add all new items (in reverse order)
    @dataView.endUpdate()

  # Called to start watching an object and propagate changes into the dataview
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
