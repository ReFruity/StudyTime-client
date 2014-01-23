config = require 'config'

module.exports = Backbone.DeepModel.extend
  sync: Backbone.cachingSync(Backbone.sync, 'schedule')

  # Schedule need to have some id for caching
  initialize: ->
    @id = "#{@get('type')}#{@get('faculty')}#{@get('group')}"

  url: ->
      "#{config.apiUrl}/schedule/#{@get('type')}/#{@get('faculty')}" + (if @has('group') then "/#{@get('group')}" else "")