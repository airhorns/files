class FDB.SecretEditController extends Backbone.Controller
  initialize: ->
    $('#secretedit').editable
      onSubmit: (content) ->
        $.ajax
          type: 'POST'
          url: "/secret_message"
          data:
            message: content.current
          success: ->
            FDB.notify("Saved.")
          error: ->
            FDB.notify("Couldn't save!")
