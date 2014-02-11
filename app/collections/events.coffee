config = require 'config/config'
Backbone = require 'backbone'
Event = require 'models/event'

module.exports = Backbone.Collection.extend
  model: Event
  url: "#{config.apiUrl}/event"

  byBounds: (bounds) ->
    @.filter (event) ->
      act =
        start: new Date event.getStart()
        end: new Date event.getEnd()
      act.start <= bounds[0] < act.end or act.start < bounds[1] <= act.end or (bounds[0] <= act.start and bounds[1] >= act.end)
