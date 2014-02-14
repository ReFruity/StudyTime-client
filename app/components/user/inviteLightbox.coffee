React = require 'react'
{span, div, ul, li, input, nav, a, i, h2, h3, p} = React.DOM
{i18n, authorized, currentUserMixin} = require '/components/common', 'authorized', 'currentUserMixin'
{classSet} = React.addons

module.exports = React.createClass
  propTypes:
    onClose: React.PropTypes.func.isRequired
    withContinue: React.PropTypes.boolean

  onClose: ->
    @props.onClose()

  getInitialState: ->
    inviteLink: 'http://studytime.me/invite/123'

  render: ->
    div {className: 'invite-lightbox'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-12 form-group link'},
            input {className: 'form-control', value: @state.inviteLink}
