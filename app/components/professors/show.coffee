#_ = require 'underscore'
React = require 'react'
{div, img, span, strong, table, tr, td} = React.DOM

#fake resource
resource =
  firstName: 'Александр',
  secondName: 'Промах',
  middleName: 'Иванович',
  image: 'http://www.vokrugsveta.ru/img/ann/news/main//2009/09/11/7391.jpg',
  address: 'Тургенева 4, ауд. 628',
  email: 's-promakh@ya.ru',
  phone: '+7-123-45-67-890'

module.exports = React.createClass
#  getInitialState: ->
#    filterQuery: ''

  render: ->
    div {id: 'professors-show'}, [
      ProfessorCard resource: resource
    ]

##########

ProfessorCard = React.createClass
  propTypes:
    resource: React.PropTypes.object.isRequired

  render: ->
    {resource} = @props
    imageUrl = if !!resource.image then resource.image else '/images/professor-no-image.png'

    div {className: 'professor'}, [
      div {className: 'container'}, [
        img src: imageUrl
      ]
      div {className: 'full-name-wrap'}, [
        div {className: 'container'}, [
          div {className: 'full-name'}, [
            strong {}, resource.secondName
            " #{resource.firstName} #{resource.middleName}"
          ]
        ]
      ]
      div {className: 'card'}, [
        div {className: 'container'}, [
          table {}, ['address', 'email', 'phone'].map (attribute) ->
            tr {}, [
              td {}, t("attributes.professor.#{attribute}")
              td {}, resource[attribute]
            ]
        ]
      ]
    ]
