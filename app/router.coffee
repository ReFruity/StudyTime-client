# Get main app component
{app} = requireComponents('/', 'app')

# Cross-environment route definition
class MainRouter extends Backbone.Router
  routes:
    "": "universities"
    "places": "places"
    "courses(/:dow)": "courses"
    "students(/:user)": "students"
    "professors(/:user)": "professors"
    ":uni": "faculties"
    ":uni/:facaulty": "groups"
    ":uni/:facaulty/:group(/:scheduleType(/:dow-:number-:atom(/:detailsView)))": "schedule"
    ":uni/:facaulty/:group(/:scheduleType(/:event(/:detailsView)))": "schedule"
    "*error": "404"

  update: ->
    React.appRenderer (app {route: @getRouteName(), params: @getParams()})

module.exports = new MainRouter
