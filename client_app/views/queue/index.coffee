FDB.registerView 'queue/index',
class FDB.QueueIndexView extends FDB.View
  initialize: ->
    this.render()

    @itemViews = {}

    @collection.bind 'add', (model) =>
      this.addItem(model)
    @collection.bind 'remove', (model) =>
      this.removeItem(model)

    @collection.each (model) ->
      this.addItem(model)


  addItem: (model) ->
    @itemViews[model.id] = view = new (FDB.view('queue/queue_item'))({model: model})
    view.render()
    @itemList.append(view.el)

  removeItem: (model) ->
    $(@itemViews[model.id].el).remove()

  render: () ->
    super
    @itemList = $('#unconfirmed_downloads', @el)
