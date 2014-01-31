# Get main app component
Router = require 'router'
app = require 'components/app'

# Cross-environment route definition
class MainRouter extends Router
  routes:
    "/": "universities"
    "/places": "places"
    "/courses(/:dow)": "courses"
    "/students(/:user)": "students"
    "/professors(/:user)": "professors"
    "/:uni": "faculties"
    "/:uni/:faculty": "groups"
    "/:uni/:faculty/:group(/:scheduleType(/:dow-:number-:atom(/:detailsView)))": "schedule"
    "/:uni/:faculty/:group(/:scheduleType(/:event(/:detailsView)))": "schedule"
    "/*error": "404"

  # Delegate rendering to some predefined function
  # (may be different in broser or node.js version)
  getAppComponent: ->
    (app {route: @getRouteName(), params: @getParams()})

module.exports = new MainRouter
