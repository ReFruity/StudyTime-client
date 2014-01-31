config = require 'config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
  sync: require('cachingSync')(Backbone.sync, 'group')
  urlRoot: "#{config.apiUrl}/group"
  idAttribute: 'name'