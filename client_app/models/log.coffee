LDB.parseTime = (timeString) ->
  return null if timeString == ''
  d = new Date
  time = timeString.match(/(\d+)(:(\d\d))?\s*(p?)/i)
  d.setHours( parseInt(time[1],10) + ( ( parseInt(time[1],10) < 12 && time[4] ) ? 12 : 0) )
  d.setMinutes( parseInt(time[3],10) || 0 )
  d.setSeconds(0, 0)
  return d

class LDB.Log extends Backbone.Model
  initialize: ->
    now = new Date
    this.set
      startDate: now
      endDate: new Date(now.getYear(), now.getMonth(), now.getDate(), now.getHours()+1, now.getMinutes())
