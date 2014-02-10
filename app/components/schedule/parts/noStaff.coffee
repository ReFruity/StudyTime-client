React = require 'react'
{span, div, a, p, button, h4} = React.DOM

module.exports = React.createClass
  render: ->
    div {className: 'no-staff'},
      div {className: 'container'},
        p {dangerouslySetInnerHTML: __html: t('schedule.texts.no_staff')}
          div {}, [
            button {className: 'btn btn-success'}, 'Я староста'
            button {className: 'btn btn-success'}, 'Пригласить старосту'
          ]