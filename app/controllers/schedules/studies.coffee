angular.module('app.controllers')

.controller('SchedulesStudiesCtrl', [
    '$scope'
    '$location'
    '$routeParams'

    ($scope, $location, $routeParams) ->
      $scope.showDetails = (dow, clazz) ->
        if $routeParams.weekDay is dow and $routeParams.classNum is clazz
          $location.path('/' + $routeParams.groupName)
        else
          $location.path('/' + $routeParams.groupName + '/' + dow + '/' + clazz)
  ])