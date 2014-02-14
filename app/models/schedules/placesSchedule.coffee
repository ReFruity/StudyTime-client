_ = require 'underscore'
config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
  url: ->
    "#{config.apiUrl}/schedule/place/#{@get('faculty')}"

  timing: ->
    @get 'timing'

  schedule: ->
    @get 'schedule'

  places: ->
    _.values @get('places')

  updatedAt: ->
    @get 'updated'



