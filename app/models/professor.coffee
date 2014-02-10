config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
#  sync: require('cachingSync')(Backbone.sync, 'group')
  urlRoot: "#{config.apiUrl}/user/"

  firstName: ->
    @get('identity').name

  secondName: ->
    @get('identity').middle_name

  middleName: ->
    @get('identity').sur_name

  imageUrl: ->
    '/images/professor-no-image.png'
