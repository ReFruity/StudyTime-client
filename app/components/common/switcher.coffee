_ = require 'underscore'
React = require 'react'
{ul, li, a} = React.DOM
{classSet} = React.addons

module.exports = React.createClass
  propTypes:
    onChange: React.PropTypes.func
    values: React.PropTypes.array

  onClick: (e, i) ->
    @props.onChange(@props.values[i]) if @props.onChange

  render: ->
    self = @
    (ul {className: 'switcher'},
      (@props.values or []).filter((v) -> v != undefined).map (v, i) ->
        (li {className: classSet('current': (if _.isString(v) then v == self.props.value else v.value == self.props.value))},
          (a {onClick: ((e)->self.onClick(e, i))}, if _.isString(v) then v else v.name or '')
        )
    )