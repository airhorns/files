class FDB.File extends Backbone.Model
  initialize: ->
    @url = "/api/1/files#{@id}"
 
  toDataRow: () ->
    segments = this.get("id").split("/")
    exts = this.get("id").split(".")
    row =
      id: this.get("id")
      type: "file"
      ext: exts[exts.length-1]
      name: segments[segments.length-1]
      modified: this.get("modified")
      size: this.get("size")
      obj: this

class FDB.FileCollection extends Backbone.Collection

