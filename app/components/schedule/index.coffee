cache = new Burry.Store('schedule');
{span, div, a} = React.DOM
{studies, exams, vacation} = requireComponents('/schedule', 'studies', 'exams', 'vacation')

##
# Component for manipulating with group star and their proxies
#
GroupStar = React.createClass
  propTypes:
    group: React.PropTypes.object.isRequired

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

##
# Main group schedule component. Contains group schedule
# of some type ('studies' by default) and group star info
# It also binds group model for getting group information.
# (group star and so on)
#
module.exports = React.createClass
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    scheduleType: 'studies'
    group: {name: @props.route.group}

  onSwitchScheduleType: (type)->
    @setState(scheduleType: type)

  render: ->
    (div {className: 'group-sched'}, [
      (if @state.group.name
        attrs = {switchTypeHandler: @onSwitchScheduleType, group: @state.group}
        switch @state.scheduleType
          when 'studies' then @transferPropsTo(studies attrs)
          when 'exams' then @transferPropsTo(exams attrs)
          when 'vacation' then @transferPropsTo(vacation attrs)
      )
      (GroupStar {group: @state.group})
    ])