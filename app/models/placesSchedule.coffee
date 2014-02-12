config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
  url: ->
    "#{config.apiUrl}/schedule/place/#{@get('faculty')}"

  timing: ->
    @get 'timing'
