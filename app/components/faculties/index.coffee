React = require 'react'
_ = require 'underscore'
{span, div, i, h2, h3, h4, button, p, input, a, img} = React.DOM
BackButton =  require '/components/helpers/backButton'

module.exports = React.createClass
  getInitialState: ->
    uni: {name: 'УрФУ', city: 'Екатеринбург', full_name: 'Уральский Федеральный Университет имени первого президента россии Б.Н. Ельцина'}
    faculties: [
      {name: 'ИМКН', full_name: 'Институт математики, механики и компьютерных наук'},
      {name: 'Ист-фак', full_name: 'Исторический факультет'},
      {name: 'ИЕН Хим-фак', full_name: 'Институт естественных наук, химический факультет'},
      {name: 'Борщ-фак'}
    ]

  render: ->
    div {className: 'faculties'},
      UniInfoRow {uni: @state.uni, route: @props.route}
      FacultiesRow {faculties: @state.faculties, route: @props.route}


UniInfoRow = React.createClass
  render: ->
    div {className: 'uni-info'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-12 uni-img'},
            BackButton()
            img {src: './images/uni-ph.jpg', className:'img-responsive'}
            div {className: 'info'},
              h2 {},
                span {className: 'name'}, @props.uni.name
                span {className: 'city'}, @props.uni.city
              h3 {}, @props.uni.full_name


FacultiesRow = React.createClass
  render: ->
    self = @
    div {className: 'unis'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-4'},
            _.map @props.faculties, (fac, indx) ->
              FacultyItem {faculty: fac, route: self.props.route} if (indx+1)%2 == 0
          div {className: 'col-sm-4'},
            _.map @props.faculties, (fac, indx) ->
              FacultyItem {faculty: fac, route: self.props.route} if (indx+1)%2 != 0 and (indx+1)%3 != 0
          div {className: 'col-sm-4'},
            _.map @props.faculties, (fac, indx) ->
              FacultyItem {faculty: fac, route: self.props.route} if (indx+1)%2 != 0 and (indx+1)%3 == 0

FacultyItem = React.createClass
  render: ->
    a {className: 'uni-item', href: "/#{@props.route.uni}/#{@props.faculty.name}"},
      h3 {}, @props.faculty.name
      h4 {}, @props.faculty.full_name



