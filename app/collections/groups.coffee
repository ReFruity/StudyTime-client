config = require 'config/config'
Backbone = require 'backbone'
Group = require 'models/group'

module.exports = Backbone.Collection.extend
  model: Group
  url: "#{config.apiUrl}/group"