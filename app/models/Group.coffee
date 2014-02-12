config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
  urlRoot: "#{config.apiUrl}/group"
  idAttribute: 'name'