config = require 'config/config'
Backbone = require 'backbone'
Faculty = require 'models/faculty'

module.exports = Backbone.Collection.extend
  model: Faculty
  url: "#{config.apiUrl}/faculty"