React = require 'react'
_ = require 'underscore'
{span, div, i, h2, h3, h4, button, p, input, a, img} = React.DOM

module.exports = React.createClass
  getInitialState: ->
    uni: {}
    faculties: [{name: 'ИМКН'}, {name: 'Ист-фак'}, {name: 'Хим-фак'}, {name: 'Борщ-фак'}]

  render: ->
    div {className: 'faculties'},
      UniInfoRow {uni: @state.uni, route: @props.route}
      FacultiesRow {faculties: @state.faculties, route: @props.route}


UniInfoRow = React.createClass
  render: ->
    div {className: 'uni-info'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-12 uni-img'},
            img {src: ''}
          div {className: 'col-md-12 uni-info'},
            span {}


FacultiesRow = React.createClass
  render: ->
    self = @
    div {className: 'faculties'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-4'},
            _.map @props.faculties, (fac, indx) ->
              FacultyItem {faculty: fac, route: self.props.route} if (indx+1)%2 == 0
          div {className: 'col-md-4'},
            _.map @props.faculties, (fac, indx) ->
              FacultyItem {faculty: fac, route: self.props.route} if (indx+1)%2 != 0 and (indx+1)%3 != 0
          div {className: 'col-md-4'},
            _.map @props.faculties, (fac, indx) ->
              FacultyItem {faculty: fac, route: self.props.route} if (indx+1)%2 != 0 and (indx+1)%3 == 0

FacultyItem = React.createClass
  render: ->
    a {className: 'fac-item', href: "/#{@props.route.uni}/#{@props.faculty.name}"},
      h3 {}, @props.faculty.name
      h4 {}, @props.faculty.full_name