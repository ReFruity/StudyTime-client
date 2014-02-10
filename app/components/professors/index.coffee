_ = require 'underscore'
React = require 'react'
{div, input, img, span, a} = React.DOM
modelMixin = require '/components/common/modelMixin'
Professors = require 'collections/professors'

module.exports = React.createClass
#  mixins: [modelMixin]
  getInitialState: ->
    filterQuery: ''
    collection: new Professors().fetchThis
      success: @forceUpdate.bind(@, null)

#  getBackboneModels: ->
#    [@state.collection]

  handleUserInput: (filterQuery) ->
    @setState filterQuery: filterQuery

  render: ->
    div {id: 'professors-index'}, [
      ProfessorsFilter filterQuery: @state.filterQuery, onUserInput: @handleUserInput
      ProfessorsList collection: @state.collection, filterQuery: @state.filterQuery
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
        img src: '/images/professors-search.png'
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

  render: ->
    i = 0
    div {className: 'professors container'},
      (@props.collection.filter (item) =>
        "#{item.secondName()} #{item.firstName()} #{item.middleName()}".toLowerCase().search(@props.filterQuery.toLowerCase()) >= 0
      ).map (item) ->
        i += 1
        if i % 4 is 0 then [ProfessorItem(item: item), div {className: 'clearfix'}] else ProfessorItem(item: item)
      div className: 'clearfix'

##########

ProfessorItem = React.createClass
  propTypes:
    item: React.PropTypes.object.isRequired

  render: ->
    {item} = @props

    a {className: 'professor col-sm-3', href: "professors/#{item.get('_id')}"}, [
      img src: item.imageUrl()
      div {className: 'name'}, [
        div {className: 'second-name'}, item.secondName()
        div {className: 'first-name'}, "#{item.firstName()} #{item.middleName()}"
      ]
    ]
