config = require 'config/config'
Backbone = require 'backbone'

Suggestion = Backbone.Model.extend
  idAttribute: 'object'

module.exports = Backbone.Collection.extend
	model: Suggestion

	url: ->
		if not @modelType
			throw new Error('You must specify modelType before making query')

		"#{config.apiUrl}/#{@modelType}"

	modelType: (type)->
		@modelType = type
		this

	find: (text)->
		@fetch
			data:
				prefix: text

