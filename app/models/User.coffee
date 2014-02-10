config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
  sync: require('cachingSync')(Backbone.sync, 'user')
  urlRoot: "#{config.apiUrl}/user"
  idAttribute: '_id'