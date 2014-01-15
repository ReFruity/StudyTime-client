'use strict'


angular.module('app.controllers')

.controller('ClassIndexCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'

    ($scope) ->
      $scope.$watch('classDetails', (newVal)->
        if newVal
          $scope.viewType = 'info'
          $scope.clazz = angular.copy(newVal)
      )
  ])