# Get main app component
app = requireComponent('app')

# Cross-environment route definition
class MainRouter extends Backbone.Router
  routes:
    "": "universities"
    "places": "places"
    "courses(/:dow)": "courses"
    "students(/:user)": "students"
    "professors(/:user)": "professors"
    ":uni": "faculties"
    ":uni/:faculty": "groups"
    ":uni/:faculty/:group(/:scheduleType(/:dow-:number-:atom(/:detailsView)))": "schedule"
    ":uni/:faculty/:group(/:scheduleType(/:event(/:detailsView)))": "schedule"
    "*error": "404"

  # Delegate rendering to some predefined function
  # (may be different in broser or node.js version)
  update: ->
    React.appRenderer (app {route: @getRouteName(), params: @getParams()})

module.exports = new MainRouter
