'use strict'

angular.module('app.controllers')

.controller('SchedulesIndexCtrl', [
    '$scope'
    'Group'
    '$routeParams'
    '$location'
    '$rootScope'

    ($scope, Group, $routeParams, $location, $rootScope) ->
      Group.lastOpened.set($routeParams.groupName)
      $rootScope.lastOpenedGroup = $routeParams.groupName

      $scope.showGroups = ->
        Group.lastOpened.set("")
        $rootScope.lastOpenedGroup = ""
        $location.path('/')

  ])