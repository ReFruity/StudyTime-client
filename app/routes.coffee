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
    "courses": "courses"
    ":group(/:dow/:clazz/:atom)": "schedule"
    "*error": "404"

  # Run React in element
  invokeComponent: (path, element, args = {}) ->
    React.renderComponent (requireComponent(path) args, []), element

  initialize: ->
    # Update footer one time and initial header update
    @invokeComponent "footer", footerElem
    @invokeComponent "header", headerElem

    # Update header and content each time
    # when route change
    @on "route", (name)->
      props = arguments[arguments.length - 1].pop()
      props = if _.isObject then props else {}
      @invokeComponent "header", headerElem, {path: name}
      @invokeComponent "#{name}/index", contentElem, props


module.exports = new MainRouter
