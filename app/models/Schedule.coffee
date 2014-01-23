config = require 'config'

ScheduleModel = Backbone.DeepModel.extend
  sync: Backbone.cachingSync(Backbone.sync, 'schedule')

  initialize: ->
    @id = "#{@get('type')}#{@get('uni')}#{@get('faculty')}#{@get('group')}"

  url: ->
      "#{config.apiUrl}/schedule/#{@get('type')}/#{@get('faculty')}" + (if @has('group') then "/#{@get('group')}" else "")

module.exports = ScheduleModel