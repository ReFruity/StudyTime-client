React = require 'react'
_ = require 'underscore'
{span, div, i, h2, h3, h4, button, p, input, a, img} = React.DOM
Universities = require '/collections/universities'
{modelMixin} = require '/components/common', 'modelMixin'

module.exports = React.createClass
  mixins: [modelMixin]

  getInitialState: ->
    unis: new Universities().fetchThis()
    loading: yes
    findMore: yes

  getBackboneModels: ->
    [@state.unis]

  focusOnSearch: ->
    _gaq.push(['_trackEvent', 'Universities', 'Search Focus Buttons'])
    @refs['searchBar'].focus()

  onModelUpdate: ->
    @setState loading: no

  findUnis: (e) ->
    self = @
    text = e.target.value
    clearTimeout(@reqTimeOut) if @reqTimeOut
    @reqTimeOut = setTimeout(->
      self.setState
        loading: yes
        findMore: not text.length
      _gaq.push(['_trackEvent', 'Universities', 'Search', text]) if text.length
      self.state.unis.find(text)
    , 60)

  render: ->
    div {className: 'home'},
      @transferPropsTo(HeaderRow {toSearchHandler: @focusOnSearch})
      @transferPropsTo(DynamicScheduleRow {})
      PointsRow {}
      @transferPropsTo(InteractiveClassesRow {})
      PointsRow {}
      @transferPropsTo(CrossbrowserRow {})
      @transferPropsTo(OtherFeaturesRow {})
      @transferPropsTo(SearchBar {ref: 'searchBar', onChange: @findUnis, loading: @state.loading})
      @transferPropsTo(UniversitiesRow {unis: @state.unis})
      if @state.findMore and not @state.loading
        @transferPropsTo(FindMoreRow {toSearchHandler: @focusOnSearch})

HeaderRow = React.createClass
  render: ->
    div {className: 'header-row'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-6 head-text'},
            div {className: 'wrap'},
              h2 {}, 'Электронное'
              h3 {}, 'расписание вузов'
              p {dangerouslySetInnerHTML: {__html: 'Акутальное расписание твоего вуза и многое другое! Легко, быстро, доступно.'}}
              button {className: 'btn btn-success btn-large', onClick: @props.toSearchHandler}, 'Найди свой ВУЗ!'
          div {className: 'col-sm-6 head-img'},
            img {src: './images/head-img.png', alt:"Anywhere"}

FindMoreRow = React.createClass
  render: ->
    div {className: 'find-more-row'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-xs-12'},
            p {}, 'И еще около 1000 ВУЗов'
            a {onClick: @props.toSearchHandler}, 'Найди свой!'

PointsRow = React.createClass
  render: ->
    div {className: 'points-row'},
      img {src: './images/hor-dots.png', className: 'hor-dots'}


DynamicScheduleRow = React.createClass
  render: ->
    div {className: 'main-feature-row one'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-6 img-col'},
            img {src: './images/vert-dots.png', className: 'vert-dots rotate-180 invisible'}
            img {src: './images/dynamic-sched.png', className: "img-responsive", alt:"Dynamic schedule"}
            img {src: './images/vert-dots.png', className: 'vert-dots'}
          div {className: 'col-sm-6 text-col'},
            h3 {}, 'Расписание в реальном времени'
            p {}, 'Все изменения в расписании отображаются в реальном времени, группы могут получать дополнительные оповещения [в социальных сетях] [и/или] [по смс]'


InteractiveClassesRow = React.createClass
  render: ->
    div {className: 'main-feature-row two'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-6 text-col'},
            h3 {}, 'Интерактивные предметы'
            p {}, 'За пару кликов вы узнаете всё про текущую пару, включая номер аудитории и фио преподавателя, а также сможете скачать все материалы, необходимые для подготовки.'
          div {className: 'col-sm-6 img-col'},
            img {src: './images/vert-dots.png', className: 'vert-dots rotate-180'}
            img {src: './images/inter-class.png', className: "img-responsive", alt:"Dynamic schedule"}
            img {src: './images/vert-dots.png', className: 'vert-dots'}


CrossbrowserRow = React.createClass
  render: ->
    div {className: 'main-feature-row three'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-6 img-col'},
            img {src: './images/vert-dots.png', className: 'vert-dots rotate-180'}
            img {src: './images/availability.png', className: "img-responsive", alt:"Dynamic schedule"}
          div {className: 'col-sm-6 text-col'},
            h3 {}, 'Доступ с любого устройства'
            p {}, 'Вы можете воспользоваться всеми предложенными функциями с любого удобного вам устройства, будь то компьютер, смартфон или планшет.'


OtherFeaturesRow = React.createClass
  render: ->
    div {className: 'other-features-row'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-4'},
            img {src: './images/places.png', alt:"Dynamic schedule"}
            h3 {}, 'Свободные аудитории'
            p {}, 'Теперь не нужно обходить все аудитории в поиске свободной, один клик и вы получите все возможные варианты.'
          div {className: 'col-sm-4'},
            img {src: './images/users.png', alt:"Dynamic schedule"}
            h3 {}, 'Преподаватели'
            p {}, 'Нужно сдать работу? Взять курсовую? Теперь не нужно искать преподавателя по всему университету.'
          div {className: 'col-sm-4'},
            img {src: './images/offline.png', alt:"Dynamic schedule"}
            h3 {}, 'Работа без интернета'
            p {}, 'Загрузите расписание один раз и вы сможете просматривать его даже без доступа к интернету.'


SearchBar = React.createClass
  focus: ->
    @refs['input'].getDOMNode().focus()

  render: ->
    div {className: 'search-bar'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-12 form-group'},
            h2 {}, 'Найди свой ВУЗ'
            input {ref: 'input', onChange: @props.onChange, className: 'form-control', placeholder: 'Поиск ВУЗа'}
            span {className: 'loading'}, 'Загрузка...' if @props.loading


UniversitiesRow = React.createClass
  render: ->
    div {className: 'unis'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-4'},
            _.map @props.unis.models, (uni, indx) ->
              UniversityItem {uni: uni} if (indx+2)%2 == 0
          div {className: 'col-sm-4'},
            _.map @props.unis.models, (uni, indx) ->
              UniversityItem {uni: uni} if (indx+2)%2 != 0 and (indx+2)%3 != 0
          div {className: 'col-sm-4'},
            _.map @props.unis.models, (uni, indx) ->
              UniversityItem {uni: uni} if (indx+2)%2 != 0 and (indx+2)%3 == 0


UniversityItem = React.createClass
  render: ->
    a {className: 'uni-item', href: "/#{@props.uni.get('name')}"},
      h3 {},
        span {className: 'name'}, @props.uni.get('name')
        span {className: 'city'}, @props.uni.get('city')
      h4 {}, @props.uni.get('full_name')

