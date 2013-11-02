'use strict'

# Declare modules with requirements
angular.module 'app.controllers', []
angular.module 'app.filters', []
angular.module 'app.services', []
angular.module 'app.directives', ['app.services']
angular.module('app', ['pascalprecht.translate'])

# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngCookies'
  'ngResource'
  'ngRoute'
  'ngAnimate'
  'app.controllers'
  'app.directives'
  'app.filters'
  'app.services'
  'partials'
])

.config([
    '$routeProvider'
    '$locationProvider'

    ($routeProvider, $locationProvider) ->
      $routeProvider

      .when('/', templateUrl: '/partials/index.html')
      .when('/terms', templateUrl: '/partials/terms.html')

      # Catch all
      .otherwise({redirectTo: '/'})

      # Without server side support html5 must be disabled.
      $locationProvider.html5Mode(if checkPhonegap() then false else true)
  ])

# FastClick
window.addEventListener('load', ->
  new FastClick(document.body)
, false);

# Phonegap checker
window.checkPhonegap = ->
  return (window.cordova || window.PhoneGap || window.phonegap) && /^file:\/{3}[^\/]/i.test(window.location.href) && /ios|iphone|ipod|ipad|android/i.test(navigator.userAgent)