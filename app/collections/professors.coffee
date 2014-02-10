config = require 'config/config'
Backbone = require 'backbone'
Professor = require 'models/professor'

module.exports = Backbone.Collection.extend
  model: Professor
  url: "#{config.apiUrl}/user?fields=identidy&role=professor"
