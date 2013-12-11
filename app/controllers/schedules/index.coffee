'use strict'

angular.module('app.controllers')

.controller('SchedulesIndexCtrl', [
    '$scope'
    'Group'
    '$routeParams'
    '$location'

    ($scope, Group, $routeParams, $location) ->
      Group.lastOpened.set($routeParams.groupName)
      $scope.showGroups = ->
        Group.lastOpened.set(undefined)
        $location.path('/')

  ])