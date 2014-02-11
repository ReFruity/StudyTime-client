_ = require 'underscore'
config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend

#  weekDay: ->
#    @get('activity') and @get('activity').start.getDay()

  subjectName: ->
    @get('subject') and @get('subject').name

  rooms: ->
    @get('place') and _.map(@get('place'), (place) -> place.name).join(' ')

  getStart: ->
    @get('activity') and new Date(@get('activity').start)

  getEnd: ->
    @get('activity') and new Date(@get('activity').end)


#  sync: require('cachingSync')(Backbone.sync, 'group')
#  urlRoot: "#{config.apiUrl}/event/"
