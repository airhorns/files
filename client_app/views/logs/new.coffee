LDB.registerView "logs/new", class LDB.NewLogView extends LDB.View
  renderable: ->
    log = super
    log.shows = [{name:"A", value:1},{name:"C",value:2},{name:"D",value:3},{name:"E", value:4}]
    log
