React = require 'react'
_ = require 'underscore'
{span, div, i, h2, h3, h4, button, p, input, a} = React.DOM

module.exports = React.createClass
  getInitialState: ->
    unis: []

  focusOnSearch: ->
    @refs['searchBar'].focus()

  findUnis: (e) ->
    @setState unis: [{name: 'Упи'}, {name: 'Ургу'}, {name: 'Урфу'}]

  render: ->
    div {className: 'home'},
      @transferPropsTo(HeaderRow {toSearchHandler: @focusOnSearch})
      @transferPropsTo(DynamicScheduleRow {})
      PointsRow {}
      @transferPropsTo(InteractiveClassesRow {})
      PointsRow {}
      @transferPropsTo(CrossbrowserRow {})
      @transferPropsTo(OtherFeaturesRow {})
      @transferPropsTo(SearchBar {ref: 'searchBar', onChange: @findUnis})
      @transferPropsTo(UniversitiesRow {unis: @state.unis})

HeaderRow = React.createClass
  render: ->
    div {className: 'header-row'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-6 head-text'},
            h2 {}, 'Электронное'
            h3 {}, 'расписание вузов'
            button {className: 'btn btn-success', onClick: @props.toSearchHandler}, 'Найди свой вуз!'
          div {className: 'col-md-6 head-img'},
            i {className: 'stico-mac-preview'}


PointsRow = React.createClass
  render: ->
    div {className: 'points-row'}


DynamicScheduleRow = React.createClass
  render: ->
    div {className: 'main-feature-row'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-6 img-col'},
            i {className: 'stico-dynamic-preview'}
          div {className: 'col-md-6 text-col'},
            h3 {}, 'Динамическое расписани'
            p {}, 'lorem'


InteractiveClassesRow = React.createClass
  render: ->
    div {className: 'main-feature-row'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-6 text-col'},
            h3 {}, 'Интерактивные предметы'
            p {}, 'lorem'
          div {className: 'col-md-6 img-col'},
            i {className: 'stico-interactiv-preview'}


CrossbrowserRow = React.createClass
  render: ->
    div {className: 'main-feature-row'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-6 img-col'},
            i {className: 'stico-crossbr-preview'}
          div {className: 'col-md-6 text-col'},
            h3 {}, 'На любом устройстве'
            p {}, 'lorem'


OtherFeaturesRow = React.createClass
  render: ->
    div {className: 'other-features-row'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-4'},
            i {className: 'stico-crossbr-preview'}
            h3 {}, 'На любом устройстве'
            p {}, 'lorem'
          div {className: 'col-md-4'},
            i {className: 'stico-crossbr-preview'}
            h3 {}, 'На любом устройстве'
            p {}, 'lorem'
          div {className: 'col-md-4'},
            i {className: 'stico-crossbr-preview'}
            h3 {}, 'На любом устройстве'
            p {}, 'lorem'


SearchBar = React.createClass
  focus: ->
    @refs['input'].getDOMNode().focus()

  render: ->
    div {className: 'search-bar'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-12 form-group'},
            input {ref: 'input', onChange: @props.onChange, className: 'form-control', placeholder: 'Поиск ВУЗа'}


UniversitiesRow = React.createClass
  render: ->
    div {className: 'unis'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-md-6'},
            _.map @props.unis, (uni, indx) ->
              UniversityItem {uni: uni} if indx%2 == 0
          div {className: 'col-md-6'},
            _.map @props.unis, (uni, indx) ->
              UniversityItem {uni: uni} if indx%2 != 0


UniversityItem = React.createClass
  render: ->
    a {className: 'uni-item', href: "/#{@props.uni.name}"},
      h3 {},
        span {className: 'name'}, @props.uni.name
        span {className: 'city'}, @props.uni.city
      h4 {}, @props.uni.full_name

