React = require 'react'
_ = require 'underscore'
{div, h3, i, span} = React.DOM

module.exports = React.createClass
  getInitialState: ->
    _.assign({}, (@props.state or {}))

  componentWillReceiveProps: (props) ->
    @setState _.assign(@state, (props.state or {}))

  render: ->
    div {className: 'preview'}, [
      div {className: 'subject'},
        if @state.subject and @state.subject.name then [
          h3 {}, [
            span {className: 'name'}, @state.subject.name
            span {className: 'type'}, t("schedule.event.types.#{@state.type}") if @state.type
          ]
        ]
        else
          h3 {className: 'enter'}, t('schedule.editor.enter_subj')

      div {className: 'professor'}, [
        i {className: 'stico-user stico-large'}

        if @state.professor and @state.professor.length
          _.map @state.professor, (prof, i) -> [
            span {className: 'comma'}, ',' if i > 0
            span {className: 'value-itm'}, prof.name
          ]
        else
          span {className: 'enter'}, t('schedule.editor.enter_proff')
      ]

      div {className: 'place'}, [
        i {className: 'stico-map stico-large'}

        if @state.place and @state.place.length then [
          span {className: 'text'}, 'в '
          _.map @state.place, (place, i) -> [
            span {className: 'comma'}, ',' if i > 0
            span {className: 'value-itm'}, place.name
          ]
          span {className: 'text'}, ' аудитории'
        ] else
          span {className: 'enter'}, t('schedule.editor.enter_place')
      ]

      div {className: 'when'}, [
        i {className: 'stico-clock stico-large'}

        if @state.type in ['lecture', 'practice'] then [
          span {className: 'value-itm'}, @state.number
          span {className: 'text'}, ' парой'
          span {className: 'comma'}, ','
        ] else if @state.type and @state._time_start and @state._time_end then [
          span {className: 'value-itm'}, getFormattedDate(@state.activity_start, 'HH:mm')
          span {className: 'text'}, ' – '
          span {className: 'value-itm'}, getFormattedDate(@state.activity_end, 'HH:mm')
          span {className: 'comma'}, ','
        ]

        if @state.half_group >= 0 then [
          switch @state.half_group
            when 0 then span {className: 'value-itm'}, 'у всей'
            when 1 then span {className: 'value-itm'}, 'у первой'
            when 2 then span {className: 'value-itm'}, 'у второй'
          switch @state.half_group
            when 0 then span {className: 'text'}, ' группы'
            when 1,2 then span {className: 'text'}, ' подгруппы'
        ]

        if 0 <= @state.parity <= 2 and @state.type in ['lecture', 'practice'] then [
          span {className: 'comma'}, ','
          switch @state.parity
            when 0 then span {className:'value-itm'}, 'каждую'
            when 1 then span {className:'value-itm'}, 'по нечетным'
            when 2 then span {className:'value-itm'}, 'по четным'
          switch @state.parity
            when 0 then (span {className: 'text'}, ' неделю')
            when 1, 2 then (span {className: 'text'}, ' неделям')
        ]
      ]
      if @state.type
        div {className: 'period'}, [
          i {className: 'stico-crosshair stico-large'}

          if @state.modifyType >= 0
            span {className: 'text'}, 'будет '

          if @state.cancelType == 3
            span {className: 'value-itm'}, 'полностью '

          switch @state.modifyType
            when 0 then span {className: 'value-itm'}, 'отменен '
            when 1 then span {className: 'value-itm'}, 'изменен '

          if @state.activity_start then [
            if @state.parity < 3 and @state.type in ['lecture', 'practice'] then [
              if not @state.cancelType then [
                span {className: 'text'}, 'по '
                span {className: 'value-itm'}, getFormattedDate(@state.activity_start, 'EEE')
              ]
              span {className: 'text'}, ' с '
            ] else
              span {className: 'text'}, 'только '

            span {className: 'value-itm'}, getFormattedDate(@state.activity_start, 'dd.MM.yyyy')
          ]

          if @state.cancelCount and @state.cancelType != 3 then [
            span {className: 'text'}, " на "
            span {className: 'value-itm'}, "#{@state.cancelCount} "
            span {className: 'value-itm'}, nt(@state.cancelCount, 'on_week')
          ]

          if @state.activity_end and @state.cancelType != 2 and @state.activity_end < new Date(1,1,2500) then [
            span {className: 'text'}, ' до '
            span {className: 'value-itm'}, getFormattedDate(@state.activity_end, 'dd.MM.yyyy')
          ]
        ]
    ]