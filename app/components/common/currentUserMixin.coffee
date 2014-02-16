React = require 'react'
_ = require 'underscore'
{User} = require '/models', 'User'

# Get current logged in user
currentUser = new User(_id: 'current').fetchThis()

# Set up window handlers for logging in
if typeof window != 'undefined'
  window.loginCallback =
    onSuccess: ->
      currentUser.fetch()
    onFailed: ->
      console.log "cant login"

##
# Mixin for tracking current logged in user
# Invoke `onUserUpdated` on any current user model update
#
module.exports =
  getCurrentUser: ->
    _.clone(currentUser.attributes)

  isUserAuthorized: ->
    if currentUser.attributes.roles then yes else no

  componentDidMount: ->
    @__userUpdater = @__onUserUpdate.bind(@, null);
    currentUser.on('add change remove fetchError', @__userUpdater, @);

  componentWillUnmount: ->
    currentUser.off(null, @__userUpdater, @)

  __onUserUpdate: ->
    if @onUserUpdate
      @onUserUpdate(@getCurrentUser())