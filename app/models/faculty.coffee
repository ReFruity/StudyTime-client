config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
  urlRoot: "#{config.apiUrl}/faculty"
  idAttribute: '_id'