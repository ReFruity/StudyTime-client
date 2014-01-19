cache = new Burry.Store('schedule');
{span, div, a} = React.DOM
{studies, exams, vacation} = requireComponents('/schedule', 'studies', 'exams', 'vacation')


GroupStar = React.createClass
  getDefaultProps: ->
    group: {}

  render: ->
    (div {className: 'container group-star'}, (
      if @props.group.star then [
        (span {}, 'староста')
        (span {}, 'ava')
        (span {}, 'zam-ava')
        (span {}, 'zam-ava')
        (a {}, ['Добавить заместителя'])
      ]
      else [
        (a {}, ['Я староста группы!'])
        (a {}, ['Пригласить старосту'])
      ]
    ))


module.exports = React.createClass
  getInitialState: ->
    scheduleType: 'studies'
    group: {name: @props.group}

  onSwitchScheduleType: (type)->
    @setState(scheduleType: type)

  render: ->
    (div {className: 'group-sched'}, [
      (if @state.group.name
        attrs = {switchTypeHandler: @onSwitchScheduleType, group: @state.group}
        switch @state.scheduleType
          when 'studies' then (studies attrs)
          when 'exams' then (exams attrs)
          when 'vacation' then (vacation attrs)
      )
      (GroupStar {group: @state.group})
    ])