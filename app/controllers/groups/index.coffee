angular.module('app.controllers')
.value('groupValues', openedSpeciality: undefined)
.run([
    '$rootScope'
    'Group'
    '$location'
    '$route'

    ($rootScope, Group, $location, $route) ->
      # Get last opened group and redirect to it
      if $location.path().length <= 1
        $rootScope.lastOpenedGroup = Group.lastOpened.get()
        if $rootScope.lastOpenedGroup and $rootScope.lastOpenedGroup.length > 0
          $location.path("/#{$rootScope.lastOpenedGroup}")

      # Executed inly once on startup
  ])
.controller('GroupsIndexCtrl', [
    '$scope'
    'config'
    'Group'
    'groupValues'
    '$location'

    ($scope, config, Group, groupValues, $location) ->
      # Chunk array
      chunkArray = (array, chunkSize) ->
        [].concat.apply [], array.map((elem, i) ->
          (if i % chunkSize then [] else [array.slice(i, i + chunkSize)])
        )

      # Get gorups handler
      $scope.openedSpeciality = groupValues.openedSpeciality
      $scope.updateGroups = (groups) ->
        $scope.groups = groups.groups
        $scope.groupKeys = chunkArray(_.keys($scope.groups), 4)

        if not $scope.openedSpeciality
          $scope.openSpeciality($scope.groupKeys[0][0])

      # Open some speciality
      $scope.openSpeciality = (spec) ->
        $scope.openedSpeciality = if spec and spec == $scope.openedSpeciality then undefined else spec
        groupValues.openedSpeciality = $scope.openedSpeciality

      # Open last opened group
      Group.list().then(
        $scope.updateGroups
      , (reason) ->
        console.log(reason)
      , $scope.updateGroups)

      # Cancel all requests on exit from schedule
      $scope.$on('$destroy', ->
        $scope.$globalRequestCancel.resolve()
      )
  ])
