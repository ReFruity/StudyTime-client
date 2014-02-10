React = require 'react'
{span, div, a, p, button, h4} = React.DOM

module.exports = React.createClass
  render: ->
    div {className: 'welcome-staff'},
      div {className: 'container'},
        p {dangerouslySetInnerHTML: __html: t('schedule.texts.welcome_staff')}
          div {},
            button {className: 'btn btn-success'}, 'Поделиться ссылкой'
            button {className: 'btn btn-success'}, 'Добавить заместителя'