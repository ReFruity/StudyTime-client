React = require 'react'
_ = require 'underscore'
{span, div, i, h2, h3, h4, button, p, input, a, img} = React.DOM
BackButton =  require '/components/helpers/backButton'
{photo, modelMixin} =  require '/components/common', 'photo', 'modelMixin'
University = require '/models/university'
Faculties = require '/collections/faculties'

module.exports = React.createClass
  mixins: [modelMixin]

  getInitialState: ->
    uni: new University(name: @props.route.uni).fetchThis(prefill:yes, expires:no)
    faculties: new Faculties().fetchThis(prefill:yes, expires:no, data:university:@props.route.uni)
    loading: yes

  getBackboneModels: ->
    [@state.uni, @state.faculties]

  render: ->
    div {className: 'faculties'},
      UniInfoRow {uni: @state.uni, route: @props.route}
      FacultiesRow {faculties: @state.faculties.models, route: @props.route}


UniInfoRow = React.createClass
  render: ->
    div {className: 'uni-info'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-12 uni-img'},
            BackButton()
            photo {className:'img-responsive', id: @props.uni.get('_id'), placeholder: 'uni-ph', format: 'jpg'} if @props.uni.has '_id'
            div {className: 'info'},
              h2 {},
                span {className: 'name'}, @props.uni.get('name') or @props.route.uni
                span {className: 'city'}, @props.uni.get('city')
              h3 {}, @props.uni.get('full_name')


FacultiesRow = React.createClass
  render: ->
    self = @
    div {className: 'unis'},
      div {className: 'container'},
        div {className: 'row'},
          if not @props.faculties.length
            div {className: 'col-sm-12'},
              span {className: 'loading'}, 'Загрузка...'
          else [
            div {className: 'col-sm-4'},
              _.map @props.faculties, (fac, indx) ->
                FacultyItem {faculty: fac, route: self.props.route} if (indx+2)%2 == 0
            div {className: 'col-sm-4'},
              _.map @props.faculties, (fac, indx) ->
                FacultyItem {faculty: fac, route: self.props.route} if (indx+2)%2 != 0 and (indx+2)%3 != 0
            div {className: 'col-sm-4'},
              _.map @props.faculties, (fac, indx) ->
                FacultyItem {faculty: fac, route: self.props.route} if (indx+2)%2 != 0 and (indx+2)%3 == 0
          ]

FacultyItem = React.createClass
  render: ->
    a {className: 'uni-item', href: "/#{@props.route.uni}/#{@props.faculty.get('name')}"},
      h3 {}, @props.faculty.get('name')
      h4 {}, @props.faculty.get('full_name')



