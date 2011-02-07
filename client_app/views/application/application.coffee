LDB.registerView "application/application", class LDB.ApplicationView extends Backbone.View
  className: "application-tabs"
  
  tabs: [{
    name: "Dashboard"
    anchor: "dashboard"
    view: 'dashboard/dashboard'
  },{
    name: "New Log"
    anchor: "new"
    view: 'logs/new'
  }]

  renderable: ->
    tabs:
      @tabs

  render: ->
    super # Renders the handlebars view
    $(@el).tabs().bind("tabsselect", this.tabChanged).tabs('select', 1).tabs('select',0) # Really stupid hack to force the first tab to render. This is dumb.

  tabChanged: (event, ui) =>
    tab = @tabs[ui.index]
    unless tab.rendered?
      # Pull the view to be rendered for this tab, render it, and append it.
      tab.rendered = (new (LDB.view(tab.view))).render()
      $(ui.panel).append(tab.rendered.el)
    true

