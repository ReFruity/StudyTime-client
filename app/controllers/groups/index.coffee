angular.module('app.controllers')

.controller('GroupsIndexCtrl', [
    '$scope'
    'config'
    'Group'

    ($scope, config, Group) ->
      #TODO: redirect to last opened group

      $scope.chunks = [];
      $scope.groups = Group.get faculty: config.facultyId, (groups) ->
        $scope.groupKeys = _.keys(groups)

        #deleting angular keys
        for key in ['$promise', '$resolved']
          $scope.groupKeys.splice($scope.groupKeys.indexOf(key), 1)
  ])
