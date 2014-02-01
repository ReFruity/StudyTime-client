React = require 'react'
{div, input, img, span} = React.DOM

module.exports = React.createClass
  render: ->

    #fake collection
    collection = [
      {firstName: 'Магаз', secondName: 'Асанов', middleName: 'Араскимович', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Александр', secondName: 'Промах', middleName: 'Иванович', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
      {firstName: 'Петров', secondName: 'Илья', middleName: 'Валерьевич', image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg'}
    ]

    div {id: 'professors-index', className: 'container'}, [
      ProfessorsFilter()
      ProfessorsList collection: collection
    ]

##########

ProfessorsFilter = React.createClass
  render: ->
    div {className: 'filter'}, [
      img src: '/images/professors-search.png'
      input type: 'text', placeholder: t('professors.index.search')
    ]

##########

ProfessorsList = React.createClass
  propTypes:
    collection: React.PropTypes.array.isRequired

  render: ->
    div {className: 'professors'},
      @props.collection.map (item) ->
        ProfessorItem item: item

##########

ProfessorItem = React.createClass
  propTypes:
    item: React.PropTypes.object.isRequired

  render: ->
    {item} = @props

    div {className: 'professor col-sm-3'}, [
      img src: item.image
      div {className: 'second-name'}, item.secondName
      div {className: 'first-name'}, "#{item.firstName} #{item.middleName}"
    ]
