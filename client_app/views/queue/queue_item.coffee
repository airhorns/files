FDB.registerView 'queue/queue_item',
class FDB.QueueItemView extends FDB.View
  tagName: 'div'
  className: 'queue_item'
  renderable: ->
    _.extend @model.toJSON(),
      unconfirmed_releases: @model.unconfirmed_releases.toJSON()

  render: ->
    super()
    $('button', @el).button()

