{span, div, a} = React.DOM

module.exports = React.createClass
  propTypes:
    mode: React.PropTypes.number.isRequired
    data: React.PropTypes.object
    switchEditorHandler: React.PropTypes.func.isRequired

  render: ->
    (div {className: 'container event-editor'}, [
      (div {className: 'row'}, [
        (span {}, 'form')
      ])
    ])
