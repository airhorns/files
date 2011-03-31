FDB.registerView "application/application", class FDB.ApplicationView extends FDB.View
  className: "application-tabs"
  _panels: {}
  tabs: [{
    name: "Dashboard"
    anchor: "dashboard"
    route: "/dashboard"
  },{
    name: "Files"
    anchor: "files"
    route: "/files"
  },{
    name: "New Log"
    anchor: "new_log"
    route: "/logs/new"
  }]

  renderable: ->
    tabs:
      @tabs

  render: ->
    super # Renders the handlebars view
    @ui = $(@el).bind("tabsshow", this.tabShown).tabs().bind("tabsselect", this.tabChanged)
    return true

  # Panel object builder, gets called for the first tab instantiated when the .tabs() is called
  tabShown: (event, ui) =>
    tab = @tabs[ui.index]
    @_panels[tab.anchor] = $(ui.panel)

  # Route updater for when a user clicks a tab. Only happens after .tabs() is called
  tabChanged: (event, ui) =>
    tab = @tabs[ui.index]
    window.location.hash = tab.route # Trigger routing cause this tab was clicked

  panel: (name) ->
    if @_panels[name]?
      return @_panels[name]
    else
      i = 0
      for tab in @tabs
        if tab.anchor == name
          @ui.tabs('select', i) # Fires event and updates hash
          return @_panels[name]
        i++
      throw "Don't have any panels anchored by #{name}!"
