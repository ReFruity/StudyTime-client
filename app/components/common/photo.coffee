React = require 'react'
Gator = require 'gator'
config = require 'config/config'
{img, span} = React.DOM
{classSet} = React.addons

##
# Component for displaying photo of the object
#
module.exports = React.createClass
  propTypes:
    size: React.PropTypes.string
    id: React.PropTypes.string
    placeholder: React.PropTypes.string
    format: React.PropTypes.string

  getDefaultProps: ->
    format: 'png'

  getInitialState: ->
    id: @props.id
    loaded: no

  onImageLoaded: (e)->
    @setState loaded: yes

  onImageError: (e)->
    @setState id: @props.placeholder

  componentWillUpdate: ->
    Gator(@refs['photoImg'].getDOMNode()).off 'load', @onImageLoaded
    Gator(@refs['photoImg'].getDOMNode()).off 'error', @onImageError

  componentDidUpdate: ->
    Gator(@refs['photoImg'].getDOMNode()).on 'load', @onImageLoaded
    Gator(@refs['photoImg'].getDOMNode()).on 'error', @onImageError

  componentDidMount: ->
    Gator(@refs['photoImg'].getDOMNode()).on 'load', @onImageLoaded
    Gator(@refs['photoImg'].getDOMNode()).on 'error', @onImageError

  componentWillUnmount: ->
    Gator(@refs['photoImg'].getDOMNode()).off 'load', @onImageLoaded
    Gator(@refs['photoImg'].getDOMNode()).off 'error', @onImageError

  render: ->
    span {className: classSet('photo-wrap': yes, 'loaded': @state.loaded)},
      @transferPropsTo(img {
        key: @state.id
        ref: 'photoImg',
        src: "#{config.s3photos}/#{@state.id}#{if @props.size then '_'+@props.size else ''}.#{@props.format}"
      })
