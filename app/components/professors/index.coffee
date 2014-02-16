_ = require 'underscore'
React = require 'react'
InfiniteScroll = require('react-infinite-scroll')(React)
{div, input, span, a, i, img} = React.DOM
{photo, modelMixin} =  require '/components/common', 'photo', 'modelMixin'
Professors = require 'collections/professors'


module.exports = React.createClass
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    filterQuery: ''
    collection: new Professors().fetchThis
      prefill: yes,
      expires: no
      data:
        university: @props.route.uni
        faculty: @props.route.faculty
      prefillSuccess: @forceUpdate.bind(@, null)

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


  getInitialState: ->
    count: 20

  loadMore: ->
    setTimeout =>
      @setState count: @state.count + 20
    , 1000

  hasMore: ->
    @state.count < @props.collection.length

  render: ->
    console.log(@state.count, @props.collection.length)
    console.log(@hasMore())

    k = 0
    div {className: 'professors container'},
      InfiniteScroll {
        loader: div({className: 'loading'}, t('messages.loading')),
        loadMore: @loadMore
        hasMore: @hasMore()
      }, [
        (@props.collection.filter (item) =>
          "#{item.secondName()} #{item.firstName()} #{item.middleName()}".toLowerCase().search(@props.filterQuery.toLowerCase()) >= 0
        )[0...@state.count].map (item) =>
          k += 1
#          console.log(k)
#          return '' if k > @state.count
          if k % 4 is 0
            [ProfessorItem(item: item, route: @props.route), div {className: 'clearfix'}]
          else
            ProfessorItem(item: item, route: @props.route)
      ]
      div className: 'clearfix'


##########

ProfessorItem = React.createClass
  propTypes:
    item: React.PropTypes.object.isRequired
    route: React.PropTypes.object.isRequired

  render: ->
    {item} = @props

    a {className: 'professor col-sm-3', href: "#{@props.route.uni}/#{@props.route.faculty}/professors/#{item.get('_id')}"}, [
      photo { id: item.get('_id'),  format: 'jpg', placeholder: 'professor-ph'} if item.get('_id')
      div {className: 'name'}, [
        div {className: 'second-name'}, item.secondName()
        div {className: 'first-name'}, "#{item.firstName()} #{item.middleName()}"
      ]
    ]
