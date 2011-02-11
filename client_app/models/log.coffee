class LDB.Log extends Backbone.Model
  initialize: ->
    now = new Date
    now.setMinutes(now.getMinutes() - now.getMinutes() % 30)
    this.set
      start_date: now
      end_date: new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours()+1, now.getMinutes())
