config = require 'config/config'
Backbone = require 'backbone'

Suggestion = Backbone.Model.extend
  idAttribute: 'object'

module.exports = Backbone.Collection.extend
	model: Suggestion

	url: ->
		if not @__modelType
			throw new Error('You must specify modelType before making query')

		"#{config.apiUrl}/#{@__modelType}"

	modelType: (type)->
		@__modelType = type
		this

	searchMethod: (type)->
		@__seachType = if type == 'prefix' then 'prefix' else 'q'
		this

	find: (text)->
		if not @__seachType or @__seachType == 'prefix'
			@fetch data: prefix: text
		else
			@fetch data: q: text

