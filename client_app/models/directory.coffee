# Wrap an optional error callback with a fallback error event.
wrapError = (onError, model, options) ->
  return (resp) ->
    if (onError)
      onError(model, resp, options)
    else
      model.trigger('error', model, resp, options)

class FDB.Directory extends Backbone.Model
  initialize: ->
    @url = "/api/1/files#{@id}"

  fetch: (options) ->
    options || (options = {})
    model = this
    success = options.success
    options.success = (resp) ->
      parsed_resp = model.parse(resp)
      normalize_resp = (x) -> x.id = x.path; x
      if files = parsed_resp['files']
        model.files = new FDB.FileCollection(_(files).chain().map(normalize_resp).map((x) -> new FDB.File(x)).value())

      if directories = parsed_resp['directories']
        model.directories = new FDB.DirectoryCollection(_(directories).chain().map(normalize_resp).map((x) -> new FDB.Directory(x)).value())

      return false if (!model.set(model.parse(resp), options))
      success(model, resp) if (success)
    options.error = wrapError(options.error, model, options)
    (this.sync || Backbone.sync)('read', this, options)
    return this

  # Recursively traverses the loaded file tree, spitting out a 1D array suitable for use by SlickGrid
  toDataView: (parent_id = null, indent = 0) ->
    tree = []
    row = _.extend(this.toDataRow(), {indent: indent, obj: this, parent: parent_id}) # Get this row's representation
    tree.push row if parent_id?
    tree = tree.concat(this.subDataView(row.id, indent+1))
    tree
  
  subDataView: (parent_row_id = this.toDataRow().id, indent) ->
    tree = []
    # Add subdirs to the tree
    if @directories?
      @directories.each (dir) ->
        tree = tree.concat dir.toDataView(parent_row_id, indent)

    # Add files in this dir to the tree
    if @files?
      @files.each (file) ->
        file = file.toDataRow()
        tree.push _.extend(file, {parent: parent_row_id, indent: indent})
    tree

  # Data object for SlickGrid representing this bad boy
  toDataRow: () ->
    segments = this.get("id").split("/")
    row =
      id: this.get("id")
      type: "dir"
      _collapsed: true
      name: segments[segments.length - 1]
      modified: this.get("modified")
      size: this.get("size")

class FDB.DirectoryCollection extends Backbone.Collection
  model: FDB.Directory
