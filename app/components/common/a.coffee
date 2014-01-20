{a} = React.DOM
router = require('router')

module.exports = React.createClass
  propTypes:
    href: React.PropTypes.string
    after: React.PropTypes.number

  render: ->
    @transferPropsTo(a {href: router.prepareHref(@props.href)}, [@props.children])