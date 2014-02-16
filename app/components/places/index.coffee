_ = require 'underscore'
React = require 'react'
{classSet} = React.addons
{span, div, a, ul, li, label, input, i} = React.DOM
PlacesSchedule = require '/models/schedules/placesSchedule'
Place = require '/models/place'
ScheduleView = require 'components/schedule/parts/schedule'
BackButton = require '/components/helpers/backButton'
nav = require '/components/schedule/parts/nav'

##########

PlacesFilter = React.createClass
  propTypes:
    filter: React.PropTypes.object

  filters: ['opened', 'big', 'projector', 'sockets']

  handleChange: ->
    filter = {}
    _.each @filters, (f) =>
      filter[f] = @refs["#{f}PlaceFilter"].getDOMNode().checked
      true #если функция вернет false то цикл прекращается
    @props.onUserInput filter

  render: ->
    div {className: 'places-filter'}, [
      ul {}, [
        _.map @filters, (filter) =>
          val = (@props.filter or {})[filter]
          li {className: classSet(active: val)}, [
            input {
              type: 'checkbox',
              id: "place-filter-#{filter}",
              ref: "#{filter}PlaceFilter",
              onChange: @handleChange,
              value: true
              checked: val
            }
            label {htmlFor: "place-filter-#{filter}"}, t("attributes.place.features.#{filter}")
          ]
      ]
    ]

##########

PlacesCell = React.createClass
  propTypes:
    data: React.PropTypes.array
#    date: React.PropTypes.object
    dow: React.PropTypes.string
    number: React.PropTypes.string
    baseUrl: React.PropTypes.string.isRequired
    bounds: React.PropTypes.array.isRequired
    route: React.PropTypes.object.isRequired
    filteredIds: React.PropTypes.array

  getDetailsHref: ->
    if @props.route.dow is @props.dow and @props.route.number is @props.number
      @props.baseUrl
    else
      "#{@props.baseUrl}/#{@props.dow}-#{@props.number}"

  filter: (shortPlace) ->
    bounds = @props.bounds
    act =
      start: new Date(shortPlace.activity.start)
      end: new Date(shortPlace.activity.end)
    byBounds = act.start <= bounds[0] < act.end or act.start < bounds[1] <= act.end or (bounds[0] <= act.start and bounds[1] >= act.end)
    byFilter = @props.filteredIds is undefined or @props.filteredIds.indexOf(shortPlace.id) >= 0
    byBounds and byFilter

  render: ->
    collection = _.filter(@props.data, @filter)
    enableDetails = collection.length > 5
    collection = if enableDetails then collection[0..4] else collection

    a {href: (if enableDetails then @getDetailsHref() else ''), className: 'place-cell cell-atom parity-0 hg-0'}, [
      div {className: 'atom-places'}, [
        if collection.length is 0
          t('messages.places_are_occupied')
        else [
          _.map collection, (place) ->
            span {className: ''}, place.name
          if enableDetails then ' ...' else undefined
        ]
      ]
    ]

##########

PlacesDetails = React.createClass
  propTypes:
    data: React.PropTypes.array.isRequired
    filteredIds: React.PropTypes.array

  filter: (place) ->
    @props.filteredIds is undefined or @props.filteredIds.indexOf(place.id) >= 0

  render: ->
    collection = _.filter(@props.data, @filter)

    div {className: classSet(container: true, 'places-details': true, fade: collection.length == 0)},
      div {className: 'places'},
        _.map collection, (place) ->
          span {}, place.name

      div {className: 'details-close'},
        a {href: "#{@props.baseUrl}"},
          i {className: 'stico-cross'}
#          span {}, t('schedule.details.close')


##########

module.exports = React.createClass
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    bounds: new Date().getWeekBounds()
    filter: {opened: true}
    placesSchedule: new PlacesSchedule(faculty: @props.route.faculty).fetchThis
      prefill: yes,
      expires: no
      prefillSuccess: @forceUpdate.bind(@, null)

  updateBounds: (bounds) ->
    @setState
      bounds: bounds

  handleUserInput: (filter) ->
    @setState filter: filter

  getFilteredIds: ->
    return undefined if _.values(@state.filter).indexOf(true) < 0
    _.map((_.filter @state.placesSchedule.places(), (place) =>
      permit = true
      _.each _.keys(@state.filter), (f) =>
        return true if !@state.filter[f]
        permit = place.features[f] is @state.filter[f]
      permit
    ), (place) ->
      place._id
    )

  render: ->
    filteredIds = @getFilteredIds()

    div {id: 'places-index'},
      div {className: 'container'},
        div {className: 'row'},
          PlacesFilter onUserInput: @handleUserInput, filter: @state.filter
          div {className: 'sched-nav'},
            nav.WeekSwitcher {switchWeekHandler: @updateBounds, bounds: @state.bounds}
          div {className: 'clearfix'}

        if @state.placesSchedule.timing() is undefined
          div {className: 'loading'}, t('messages.loading')
        else
          ScheduleView(
            weekDate: @state.bounds[0]
            cellElem: PlacesCell
            detailsElem: PlacesDetails
            sched: @state.placesSchedule.schedule() or {}
            timing: @state.placesSchedule.timing() or {}
            details: (
              try
                if @state.placesSchedule.schedule()[@props.route.dow][@props.route.number]
                  dow: @props.route.dow
                  number: @props.route.number
                  data: @state.placesSchedule.schedule()[@props.route.dow][@props.route.number]
                  filteredIds: filteredIds
              catch e
                undefined
            )
            cellProps:
              route: @props.route
              baseUrl: "/#{@props.route.uni}/#{@props.route.faculty}/places"
              bounds: @state.bounds
              filteredIds: filteredIds
          )
