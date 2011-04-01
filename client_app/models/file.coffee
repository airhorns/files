class FDB.File extends Backbone.Model
  initialize: ->
    @url = "/api/1/files#{@id}"
 
  toDataRow: () ->
    segments = this.get("id").split("/")
    depth = segments.length-1
    exts = this.get("id").split(".")
    row = _.extend this.toJSON(),
      type: "file"
      ext: exts[exts.length-1]
      name: segments[depth]
      obj: this
      indent: depth - 1

class FDB.FileCollection extends Backbone.Collection

