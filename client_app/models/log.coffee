class LDB.Log extends Backbone.Model
  initialize: ->
    now = new Date
    now.setMinutes(now.getMinutes() - now.getMinutes() % 30)
    end = new Date
    end.setTime(now.valueOf() + 60*1000*60)
    this.set
      start_date: now
      end_date: end
