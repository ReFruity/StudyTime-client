config = require 'config/config'
Backbone = require 'backbone'
University = require 'models/university'

module.exports = Backbone.Collection.extend
  model: University
  url: "#{config.apiUrl}/university"

  find: (text)->
    @fetch
      data:
        q: text