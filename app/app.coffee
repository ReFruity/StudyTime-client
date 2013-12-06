'use strict'

# Declare modules with requirements
angular.module 'app.controllers', []
angular.module 'app.filters', []
angular.module 'app.services', []
angular.module 'app.animations', []
angular.module 'app.directives', ['app.services']


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
  'app.templates'
  'app.animations'
  'LocalStorageModule'
])
.config([
    '$routeProvider'
    '$locationProvider'

    ($routeProvider, $locationProvider) ->
      $routeProvider

      .when('/', templateUrl: 'app/partials/groups/index.jade', controller: 'GroupsIndexCtrl')
      .when('/terms', templateUrl: 'app/partials/terms.jade')
      .when('/places', templateUrl: 'app/partials/places/index.jade', controller: 'PlacesIndexCtrl')
      .when('/courses', templateUrl: 'app/partials/courses/index.jade', controller: 'CoursesIndexCtrl')
      .when('/:groupName/:weekDay?/:classNum?/:atomClass?',
          templateUrl: 'app/partials/schedules/index.jade',
          controller: 'SchedulesIndexCtrl',
          preventNestedReload: true
        )
      .otherwise({redirectTo: '/'})

      # Without server side support html5 must be disabled.
      $locationProvider.html5Mode(true)
  ])

.run([
    '$rootScope'
    '$location'
    '$cookies'
    '$route'
    '$routeParams'

    ($rootScope, $location, $cookies, $route, $routeParams) ->
      $rootScope.$route = $route
      $rootScope.$location = $location
      $rootScope.$routeParams = $routeParams
      $rootScope.in = (val, arr) ->
        return val in arr
  ])

# FastClick
window.addEventListener('load', ->
    FastClick.attach(document.body);
, false)

# Phonegap checker
window.checkPhonegap = ->
  return (window.cordova || window.PhoneGap || window.phonegap) && /^file:\/{3}[^\/]/i.test(window.location.href) && /ios|iphone|ipod|ipad|android/i.test(navigator.userAgent)

# Detect Apple StandAlone or PhoneGap application and
# add css class to html
if navigator.standalone or checkPhonegap()
  angular.element(document.documentElement).addClass('standalone')
if checkPhonegap()
  angular.element(document.documentElement).addClass('phonegap')