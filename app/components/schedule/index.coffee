cache = new Burry.Store('schedule');
{span, div, a} = React.DOM
{studies, exams, vacation} = requireComponents('/schedule', 'studies', 'exams', 'vacation')
{modelMixin} = requireComponents('/common', 'modelMixin')
{Group} = requireModels('Group')

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
  mixins: [modelMixin]
  propTypes:
    route: React.PropTypes.object.isRequired

  getInitialState: ->
    group: new Group({name: @props.route.group}).fetchThis()

  getBackboneModels: ->
    [@state.group]

  render: ->
    (div {className: 'group-sched'}, [
      (if @state.group.get('name')
        switch @props.route.scheduleType
          when 'studies' then @transferPropsTo(studies {group: @state.group})
          when 'exams' then @transferPropsTo(exams {group: @state.group})
          when 'vacation' then @transferPropsTo(vacation {group: @state.group})
          else @transferPropsTo(studies {group: @state.group})
      )
      (GroupStar {group: @state.group})
    ])