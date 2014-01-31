##
# Router implementatino selector
# It exports implementation depends on current
# environment (browser or node.js)
#
_ = require 'underscore'
config = require 'config'
Backbone = require 'backbone'
React = require 'react'

# Server-side implementation using Express.js
if typeof window == 'undefined'
  app = nativeRequire('express')()

serverRoute = (route, name, callback) ->
  route = @_routeToRegExp(route)
  app.get(route.regex, (req, res)->
    res.send(name);
  )
	# TODO


# Client-seide implementation of route binding
# using Backbone.History
clientRoute = (route, name, callback) ->
  # RegEx route not supported.
  throw new Error("RegEx route not supported!")  if _.isRegExp(route)

  # Create regex from string
  route = if route[0] == '/' then route.substr(1) else route
  route = @_routeToRegExp(route)

  # Create callback function
  if _.isFunction(name)
    callback = name
    name = ""
  callback = this[name]  unless callback

  # Bind to history
  router = this
  Backbone.history.route route.regex, (fragment) ->
    args = router._extractParameters(route.regex, fragment)
    router._lastParams = {}
    _.map(args, (v, i) ->
    	router._lastParams[route.names[i]] = v
    )
    router._lastName = name

    # Rerender component
    React.renderComponent(router.getAppComponent(), document.getElementById('content'))
    Backbone.history.trigger "route", router, name, args

  this


# Cached regular expressions for matching named param parts and splatted
# parts of route strings.
optionalParamOpen = /\(/g
optionalParamClose = /\)/g
namedParam = /(\(\?)?:\w+/g
splatParam = /\*\w+/g
escapeRegExp = /[\-{}\[\]+?.,\\\^$|#\s]/g


# Fork of Backbone.Router with client/server `route`
# implementation and nested optional route definition
module.exports = class Router
	# Bind all routes to Backbone.History
	constructor: (options={})->
    @routes = options.routes if options.routes
    @_bindRoutes()
    @initialize.apply(@, arguments);

  # Override to make some initialization
  initialize: ->
    if app
      app.listen(config.serverPort)
      console.log "Server started at #{config.serverPort}"

  # Override this for making all things to work
  getAppComponent: ->
  	throw new Error('You must specify \'getAppComponent\' method that returns your main app component')

  # Return last route params object
  getParams: ->
    @_lastParams

  # Return last route name string
  getRouteName: ->
    @_lastName

  # Simple proxy to `Backbone.history` to save a fragment into the history.
  navigate: (fragment, options) ->
    Backbone.history.navigate(fragment, options)
    this

  # Bind all defined routes to `Backbone.history`. We have to reverse the
  # order of the routes here to support behavior where the most general
  # routes can be defined at the bottom of the route map.
  _bindRoutes: ->
    return  unless @routes
    @routes = _.result(this, "routes")
    routes = _.keys(@routes)
    getNext = if app then routes.shift else routes.pop
    @_route(route, @routes[route]) while (route = getNext.apply(routes))?

  # Manually bind a single named route to a callback. For example:
  #
  #     this.route('search/:query/p:num', 'search', function(query, num) {
  #       ...
  #     });
  #
  _route: (if typeof window == 'undefined' then serverRoute else clientRoute)

  # Convert a route string into a regular expression, suitable for matching
  # against the current location hash.
  _routeToRegExp: (route) ->
    names = []
    route = route.replace(escapeRegExp, "\\$&").replace(optionalParamOpen, "(?:").replace(optionalParamClose, ")?").replace(namedParam, (match, optional) ->
      names.push match.substr(1)
      (if optional then match else "([^/]+)")
    ).replace(splatParam, "(.*?)")
    regex: new RegExp("^" + route + "$")
    names: names

  # Given a route, and a URL fragment that it matches, return the array of
  # extracted decoded parameters. Empty or unmatched parameters will be
  # treated as `null` to normalize cross-browser behavior.
  _extractParameters: (route, fragment) ->
    params = route.exec(fragment).slice(1)
    _.map params, (param) ->
      (if param then decodeURIComponent(param) else null)
