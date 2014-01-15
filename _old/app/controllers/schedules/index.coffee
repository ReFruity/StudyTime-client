'use strict'

angular.module('app.controllers')

.controller('SchedulesIndexCtrl', [
    '$scope'
    'Group'
    '$routeParams'
    '$location'
    '$rootScope'

    ($scope, Group, $routeParams, $location, $rootScope) ->
      # Set last opened group in cache
      Group.lastOpened.set($routeParams.groupName)
      $rootScope.lastOpenedGroup = $routeParams.groupName

      # Show groups list (remove last opened group from cache)
      $scope.showGroups = ->
        Group.lastOpened.set("")
        $rootScope.lastOpenedGroup = ""
        $location.path('/')

      # Change showing schedule type
      $scope.showingState = Group.lastShowedState.get($routeParams.groupName) or "studies"
      $scope.showScheduleType = (type)->
        Group.lastShowedState.set($routeParams.groupName, type)
        $scope.showingState = type
        $location.path("/" + $routeParams.groupName)

      # Get group object for showing schedule with some type
      Group.get($routeParams.groupName).then(updateGroup, updateRejected, updateGroup)
      updateGroup = (group) ->
        $scope.group = group
      updateRejected = (reason) ->
        console.log "group update rejected"

        # Cancel all requests on exit from schedule
      $scope.$on('$destroy', ->
        $scope.$globalRequestCancel.resolve()
      )
  ])