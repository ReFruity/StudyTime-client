React = require 'react'
{span, div, ul, li, nav, a, i, h2, h3, p} = React.DOM
{i18n, authorized, currentUserMixin} = require '/components/common', 'authorized', 'currentUserMixin'
{classSet} = React.addons

module.exports = React.createClass
  propTypes:
    onClose: React.PropTypes.func.isRequired
    withContinue: React.PropTypes.boolean

  onClose: ->
    @props.onClose()

  render: ->
    div {className: 'login-lightbox'},
      h2 {}, 'Войдите'
      p {}, ', используюя одну из социальных сетей'
      div {className: 'row'},
        div {className: 'col-xs-6'},
          div {}, 'ВК'
        div {className: 'col-xs-6'},
          div {}, 'ФБ'