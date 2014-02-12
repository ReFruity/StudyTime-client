config = require 'config/config'
Backbone = require 'backbone'

ScheduleModel = Backbone.Model.extend
  initialize: ->
    @id = "#{@get('type')}#{@get('uni')}#{@get('faculty')}#{@get('group')}"

  url: ->
    "#{config.apiUrl}/schedule/#{@get('type')}/#{@get('faculty')}" + (if @has('group') then "/#{@get('group')}" else "")

module.exports = ScheduleModel