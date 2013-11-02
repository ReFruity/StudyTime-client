GroupCtrl = ($scope, Group, $routeParams, $location) ->
  $scope.group = Group.get(groupName: $routeParams.groupName)
GroupCtrl.$inject = ["$scope", "Group", "$routeParams", "$location"]