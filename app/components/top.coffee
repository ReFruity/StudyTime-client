{ul, li, div, h5, h4, form, input, button, span, a} = React.DOM

count = 0

TodoList = React.createClass
  render: ->
    console.log count
    count += 1
    (a {href: "test"}, ['Test link']);

module.exports = TodoList