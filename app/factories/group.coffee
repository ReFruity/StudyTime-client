angular.module('app.services').factory "Group", ($resource, config) ->
  $resource config.apiUrl + '/group/:_method', {},
    query:
      method: "GET"
      isArray: false

#  $scope.group = Group.get({groupName: $routeParams.groupName});

#    cut:
#      method: "GET"
#      params:
#        _method: "cut"
