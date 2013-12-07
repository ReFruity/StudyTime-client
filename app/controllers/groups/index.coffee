angular.module('app.controllers')

.controller('GroupsIndexCtrl', [
    '$scope'
    'config'
    'Group'

    ($scope, config, Group) ->
      #TODO: redirect to last opened group

      $scope.updateGroups = (groups) ->
        $scope.groups = groups
        $scope.groupKeys = _.keys($scope.groups)

      Group.get(faculty: config.facultyId).then(
        $scope.updateGroups
        , (reason) ->
          console.log(reason)
        , $scope.updateGroups
      )


      #deleting angular keys

  ])
