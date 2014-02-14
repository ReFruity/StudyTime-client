# Get main app component
Router = require 'router'
app = require 'components/app'

# Cross-environment route definition
class MainRouter extends Router
  routes:
    "/": "universities/index"
    "/:uni": "faculties/index"
    "/:uni/:faculty": "groups/index"
    "/:uni/:faculty/professors": "professors/index"
    "/:uni/:faculty/professors/:id": "professors/show"
    "/:uni/:faculty/editor": "groups/editor"
    "/:uni/:faculty/places": "places/index"
    "/:uni/:faculty/places(/:dow-:number)": "places/index"
    "/:uni/:faculty/courses(/:dow)": "courses/index"
    "/:uni/:faculty/students(/:user)": "students/index"
    "/:uni/:faculty/:group(/:scheduleType(/:dow-:number-:atom(/:detailsView)))": "schedule/index"
    "/:uni/:faculty/:group(/:scheduleType(/:event(/:detailsView)))": "schedule/index"
    "/*error": "404/index"

  getAppComponent: ->
    (app {route: @getRouteName(), params: @getParams()})

module.exports = new MainRouter
