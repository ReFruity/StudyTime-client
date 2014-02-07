React = require 'react'
config = require 'config/config'
lightbox = require 'lightbox'
{currentUserMixin} = require '/components/common', 'currentUserMixin'
{span, div, a} = React.DOM
{classSet} = React.addons

##
# Component for authorized clicks
#
module.exports = React.createClass
  mixins: [currentUserMixin]

  propTypes:
    onClick: React.PropTypes.func
    elem: React.PropTypes.func

  getDefaultProps: ->
    elem: span

  # Invoke click handler if clicked
  # and new user object not banned
  onUserUpdate: (user) ->
    return if not @__authClicked
    @__authClicked = no

    if user and user.roles
      if 'banned' not in user.roles
        @props.onClick(e) if @props.onClick
      else
        @showBannedLightbox()
      yes
    no

  # Handle click on the component
  # and create gate to auth process if
  # current user not logged in
  onClick: (e)->
    @__authClicked = yes
    if not @onUserUpdate(@getCurrentUser())
      @showAuthLightbox()

  showBannedLightbox: ->
    console.log 'banned'

  showAuthLightbox: ->
    document.domain = config.domain
    wnd = window.open('https://oauth.vk.com/authorize?client_id=3509560&redirect_uri=http://api.studytime.me/api/v2/auth/vk&display=popup&scope=&v=5.5&response_type=code', 'VK Auth', 'height=400,width=600')
    if window.focus then wnd.focus()

  render: ->
    @transferPropsTo(@props.elem {onClick: @onClick}, @props.children)
