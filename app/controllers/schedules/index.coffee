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
      $rootScope.scheduleLoading = yes

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

      # Opend class details
      $scope.showDetails = (dow, clazz, atom) ->
        $scope.columnIndex = atom
        if $routeParams.weekDay is dow and $routeParams.classNum is clazz and $routeParams.atomClass is atom + ""
          $location.path('/' + $routeParams.groupName)
        else
          $location.path('/' + $routeParams.groupName + '/' + dow + '/' + clazz + '/' + atom)

      # Close details
      $scope.closeDetails = ->
        $location.path('/' + $routeParams.groupName)

      # Get group object for showing schedule with some type
      Group.get($routeParams.groupName).then(
        updateGroup
      , (reject_reason) ->
        console.log "group getting rejected"
      , updateGroup)
  ])