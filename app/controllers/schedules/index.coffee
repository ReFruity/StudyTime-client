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

      # Remove last opened group from cache
      $scope.showGroups = ->
        Group.lastOpened.set("")
        $rootScope.lastOpenedGroup = ""
        $location.path('/')

      # Change showing schedule type
      $scope.showingState = Group.lastShowedState.get($routeParams.groupName)
      $scope.showScheduleType = (type)->
        Group.lastShowedState.set($routeParams.groupName, type)
        $scope.showingState = type
        $location.path("/"+$routeParams.groupName)

      # Update group object and showing schedule type if needed
      updateGroup = (group) ->
        $scope.group = group
        if not $scope.showingState or $scope.showingState.length == 0
          $scope.showScheduleType(group.state)

      # Get group object for showing schedule with some type
      Group.get($routeParams.groupName).then(
        updateGroup
      , (reject_reason) ->
        console.log "group getting rejected"
      , updateGroup)
  ])