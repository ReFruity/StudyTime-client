config = require 'config/config'
Backbone = require 'backbone'
Event = require 'models/event'

module.exports = Backbone.Collection.extend
  model: Event
  url: "#{config.apiUrl}/event"
