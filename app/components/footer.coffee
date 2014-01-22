{span, footer} = React.DOM

module.exports = React.createClass
  shouldComponentUpdate: ->
    no

  render: ->
    (footer {}, [
      (span {}, ['Footer'])
    ])