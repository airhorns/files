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
      @view.render()
      
      # Generate the data to begin with
      if @root.fetched
        this.generateData()
      else
        @root.bind "change", this.generateData
        
      @view.bind "rowClicked", this.updateLog

  # Performs the first generation of the tree
  generateData: () =>
    @log = @root.toDataView()
    @view.dataView.setItems(@log)
  
  # Adds a newly toggled dir to the tree (well, into the log)
  updateLog: (item, args, e) =>
    insert = () =>
      @view.dataView.beginUpdate()
      items = item.obj.subDataView(item.id, item.indent+1)
      indexOfOpened = @view.dataView.getIdxById(item.id)
      for i, newItem of items
        @view.dataView.insertItem(indexOfOpened+1, items[items.length-1-i])
      @view.dataView.endUpdate()

    toggle = () =>

    unless item.obj.fetched
      item.obj.fetch
        success: -> insert() and toggle()
    else
      toggle()
