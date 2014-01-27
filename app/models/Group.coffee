config = require 'config'

module.exports = Backbone.DeepModel.extend
  sync: Backbone.cachingSync(Backbone.sync, 'group')
  urlRoot: "#{config.apiUrl}/group"
  idAttribute: 'name'