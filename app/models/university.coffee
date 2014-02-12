config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
  sync: require('cachingSync')(Backbone.sync, 'uni')
  urlRoot: "#{config.apiUrl}/university"
  idAttribute: '_id'