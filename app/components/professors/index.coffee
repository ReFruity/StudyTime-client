_ = require 'underscore'
React = require 'react'
{div, input, span, a, i, img} = React.DOM
modelMixin = require '/components/common/modelMixin'
Professors = require 'collections/professors'


module.exports = React.createClass
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    filterQuery: ''
    collection: new Professors().fetchThis
      data:
        university: @props.route.uni
        faculty: @props.route.faculty
      success: @forceUpdate.bind(@, null)

  handleUserInput: (filterQuery) ->
    @setState filterQuery: filterQuery

  render: ->
    div {id: 'professors-index'}, [
      ProfessorsFilter filterQuery: @state.filterQuery, onUserInput: @handleUserInput
      ProfessorsList collection: @state.collection, filterQuery: @state.filterQuery, route: @props.route
    ]

##########

ProfessorsFilter = React.createClass
  propTypes:
    filterQuery: React.PropTypes.string

  handleChange: ->
    @props.onUserInput(
      @refs.filterQueryInput.getDOMNode().value,
    )

  render: ->
    div {className: 'container'}, [
      div {className: 'filter'}, [
        i className: 'professors-search'
        input
          className: 'form-control'
          type: 'text',
          placeholder: t('professors.index.search'),
          value: @props.filterQuery,
          onChange: @handleChange
          ref: "filterQueryInput"
      ]
    ]

##########

ProfessorsList = React.createClass
  propTypes:
    collection: React.PropTypes.object.isRequired
    filterQuery: React.PropTypes.string
    route: React.PropTypes.object.isRequired

  render: ->
    k = 0
    div {className: 'professors container'},
      (@props.collection.filter (item) =>
        "#{item.secondName()} #{item.firstName()} #{item.middleName()}".toLowerCase().search(@props.filterQuery.toLowerCase()) >= 0
      ).map (item) =>
        k += 1
        if k % 4 is 0
          [ProfessorItem(item: item, route: @props.route), div {className: 'clearfix'}]
        else
          ProfessorItem(item: item, route: @props.route)
      div className: 'clearfix'

##########

ProfessorItem = React.createClass
  propTypes:
    item: React.PropTypes.object.isRequired
    route: React.PropTypes.object.isRequired

  render: ->
    {item} = @props

    a {className: 'professor col-sm-3', href: "#{@props.route.uni}/#{@props.route.faculty}/professors/#{item.get('_id')}"}, [
      img src: item.imageUrl()
      div {className: 'name'}, [
        div {className: 'second-name'}, item.secondName()
        div {className: 'first-name'}, "#{item.firstName()} #{item.middleName()}"
      ]
    ]
