# Sugar for requiring components
window.requireComponent = (path)->
  require("components/#{path}")

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
    ":group(/:dow/:clazz/:atom)": "schedule"
    "*error": "404"

  # Run React in element
  invokeComponent: (path, element, args = {}) ->
    React.renderComponent (requireComponent(path) args, []), element

  # Update footer one time and initial header update
  initialize: ->
    @invokeComponent "footer", footerElem
    @invokeComponent "header", headerElem

  # Update interface with last route name and props
  update: ->
    @invokeComponent "header", headerElem, {path: @_lastName}
    @invokeComponent "#{@_lastName}/index", contentElem, @_lastProps


module.exports = new MainRouter
