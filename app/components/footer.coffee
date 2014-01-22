{span, footer} = React.DOM

module.exports = React.createClass
  render: ->
    (footer {}, [
      (span {}, ['Footer'])
    ])