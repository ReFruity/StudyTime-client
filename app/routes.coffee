# Get main app component
Router = require 'router'
app = require 'components/app'

# Cross-environment route definition
class MainRouter extends Router
  routes:
    "/": "universities/index"
    "/places": "places/index"
    "/courses(/:dow)": "courses/index"
    "/students(/:user)": "students/index"
    "/professors(/:id)": "professors/show"
    "/:uni": "faculties/index"
    "/:uni/:faculty": "groups/index"
    "/:uni/:faculty/professors": "professors/index"
    "/:uni/:faculty/editor": "groups/editor"
    "/:uni/:faculty/:group(/:scheduleType(/:dow-:number-:atom(/:detailsView)))": "schedule/index"
    "/:uni/:faculty/:group(/:scheduleType(/:event(/:detailsView)))": "schedule/index"
    "/*error": "404/index"

  getAppComponent: ->
    (app {route: @getRouteName(), params: @getParams()})

module.exports = new MainRouter
