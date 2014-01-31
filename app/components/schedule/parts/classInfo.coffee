React = require 'react'
{span, div, a} = React.DOM

##
# Information about event (class)
# Event must be pushed in `data` attribute
#
module.exports = React.createClass
  propTypes:
    data: React.PropTypes.object.isRequired

  render: ->
    (div {className: 'details-info'}, [
      (if @props.data.subject
        (div {className: 'info-header'}, [
          (span {className: 'hedaer-name'}, @props.data.subject.name)
          ((@props.data.place or []).map (place)->
            (span {className: 'hedaer-place'}, place.name)
          )
        ])
      )
      (if @props.data.professor
        (div {className: 'info-prof'}, [
          (@props.data.professor.map (prof)->
            (a {href: "/professors/#{prof.object}", className: 'prof-name'}, prof.name)
          )
        ])
      )
      (if @props.data.description
        (div {className: 'info-desc'}, [
          (span {}, @props.data.description)
        ])
      )
    ])