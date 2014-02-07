React = require 'react'
{span, footer, div, a, i} = React.DOM

module.exports = React.createClass
  shouldComponentUpdate: ->
    no

  showFeedback: ->
    (window.UserVoice or []).push [
      'showLightbox'
      'classic_widget'
      {mode: 'feedback', primary_color: '#373d3f', link_color: '#2c8079', forum_id: 199181}
    ]

  render: ->
    footer {},
      div {className: 'container'},
        div {className: 'row first-row'},
          div {className: 'left-foot'},
            a {className: 'feedback', onClick: @showFeedback}, 'Отзывы и предложения'
          div {className: 'right-foot'},
            a {}, 'О проекте'
            a {}, 'Соглашение'
            a {}, 'Кто авторы?'
        div {className: 'row'},
          div {className: 'left-foot'},
            span {}, '© 2014 StudyTime.me'
            span {}, 'Дизайн – Анна Черных'
          div {className: 'st-clock'}
          div {className: 'right-foot'},
            div {className: 'widgets'},
              a {href: 'https://twitter.com/StudyTimeMe', target: "_blank", className:'widget widget-twitter'},
                i {className: 'stico-twitter'}
              a {href: 'http://vk.com/study_time_me', target: "_blank", className: 'widget widget-vk'},
                i {className: 'stico-vk'}
              a {href: '#', className: 'widget widget-facebook'},
                i {className: 'stico-fb'}