config = require 'config/config'
Backbone = require 'backbone'
Professor = require 'models/professor'

module.exports = Backbone.Collection.extend
  model: Professor
#  sync: require('cachingSync')(Backbone.sync, 'professors'),
  url: "#{config.apiUrl}/user?fields=identity&role=professor"


