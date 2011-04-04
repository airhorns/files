# Wrap an optional error callback with a fallback error event.
wrapError = (onError, model, options) ->
  return (resp) ->
    if (onError)
      onError(model, resp, options)
    else
      model.trigger('error', model, resp, options)

# -------------------
# Directory Class - represents a folder on the file system
# -------------------
class FDB.Directory extends Backbone.Model

  initialize: ->
    @url = "/api/1/files#{@id}"

  # Overridden backbone method to have the hook in the middle
  fetch: (options) ->
    options || (options = {})
    model = this
    success = options.success

    options.success = (resp) ->
      parsed_resp = model.parse(resp)
      normalize_resp = (x) -> x.id = x.path; x
      # Setup files and dirs
      if files = parsed_resp['files']
        delete parsed_resp['files']
        model.files = new FDB.FileCollection(_(files).chain().map(normalize_resp).map((x) -> new FDB.File(x)).value())
        model._changed = true

      if directories = parsed_resp['directories']
        delete parsed_resp['directories']
        model.directories = new FDB.DirectoryCollection(_(directories).chain().map(normalize_resp).map((x) -> new FDB.Directory(x)).value())
        model._changed = true
      model.fetched = true

      return false if (!model.set(parsed_resp, options))
      success(model, resp) if (success)
    options.error = wrapError(options.error, model, options)
    (this.sync || Backbone.sync)('read', this, options)
    return this

  # Recursively traverses the loaded file tree, spitting out a 1D array suitable for use by SlickGrid
  toDataView: (parent_id = null) ->
    tree = []
    row = _.extend(this.toDataRow(), {parent: parent_id}) # Get this row's representation
    tree.push row if parent_id?
    tree = tree.concat(this.subDataView(row.id))
    tree
  
  subDataView: (parent_row_id = this.toDataRow().id) ->
    tree = []
    # Add subdirs to the tree
    if @directories?
      @directories.each (dir) ->
        tree = tree.concat dir.toDataView(parent_row_id)

    # Add files in this dir to the tree
    if @files?
      @files.each (file) ->
        file = file.toDataRow()
        tree.push _.extend(file, {parent: parent_row_id})
    tree

  # Data object for SlickGrid representing this bad boy
  toDataRow: () ->
    row = _.extend this.toJSON(),
      type: "dir"
      name: this.name()
      obj: this
      indent: this.get("id").split("/").length - 3
        
  
  name: () ->
    segments = this.get("id").split("/")
    s = segments[segments.length - 2]
    s += " (empty)" if @fetched and @directories.length == 0 and @files.length == 0
    s

class FDB.DirectoryCollection extends Backbone.Collection
  model: FDB.Directory
