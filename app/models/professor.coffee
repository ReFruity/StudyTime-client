config = require 'config/config'
Backbone = require 'backbone'

module.exports = Backbone.Model.extend
  urlRoot: "#{config.apiUrl}/user/"

  firstName: ->
    @get('identity') and @get('identity').name

  secondName: ->
    @get('identity') and @get('identity').sur_name

  middleName: ->
    @get('identity') and @get('identity').middle_name

  address: ->
    t 'messages.not_indicate'

  email: ->
    t 'messages.not_indicate'

  phone: ->
    t 'messages.not_indicate'

  imageUrl: ->
    '/images/professor-no-image.png'
