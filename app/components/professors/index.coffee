_ = require 'underscore'
React = require 'react'
{div, input, img, span} = React.DOM

module.exports = React.createClass
  getInitialState: ->
    filterQuery: ''

  handleUserInput: (filterQuery) ->
    @setState filterQuery: filterQuery

  render: ->

    #fake collection
    collection = [
      {firstName: 'Магаз', secondName: 'Асанов', middleName: 'Араскимович', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Александр', secondName: 'Промах', middleName: 'Иванович', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: ''}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
    ]

    div {id: 'professors-index'}, [
      ProfessorsFilter filterQuery: @state.filterQuery, onUserInput: @handleUserInput
      ProfessorsList collection: collection, filterQuery: @state.filterQuery
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
    collection: React.PropTypes.array.isRequired
    filterQuery: React.PropTypes.string

  render: ->
    i = 0
    div {className: 'professors container'},
      _.filter(@props.collection,(item) =>
        "#{item.firstName} #{item.secondName} #{item.middleName}".toLowerCase().search(@props.filterQuery.toLowerCase()) >= 0
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
    imageUrl = if !!item.image then item.image else '/images/professor-no-image.png'

    div {className: 'professor col-sm-3'}, [
      img src: imageUrl
      div {className: 'name'}, [
        div {className: 'second-name'}, item.secondName
        div {className: 'first-name'}, "#{item.firstName} #{item.middleName}"
      ]
    ]
