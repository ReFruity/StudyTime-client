# Cache of placeholder elements
contentElem = $('#content')[0]
headerElem = $('header')[0]
footerElem = $('footer')[0]

# Main router. Defines all pathes in the app
class MainRouter extends Backbone.Router
  # Site map
  routes:
    "": "groups"
    "places": "places"
    "courses(/:dow)": "courses"
    "students(/:user)": "students"
    "professors(/:user)": "professors"
    ":group(/:dow/:number/:atom)": "schedule"
    ":group(/:event)": "schedule"
    "*error": "404"

  # Run React in element
  invokeComponent: (path, element, args = {}) ->
    React.renderComponent (requireComponent(path) args, []), element

  # Update footer one time and initial header update
  initialize: ->
    @invokeComponent "footer", footerElem
    @invokeComponent "header", headerElem

  # Update interface with last route name and props
  # Invoked when history changed and event triggered
  update: ->
    @invokeComponent "header", headerElem, {path: @_lastName}
    @invokeComponent "#{@_lastName}/index", contentElem, {route: @_lastProps}


module.exports = new MainRouter
