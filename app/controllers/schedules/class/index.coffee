'use strict'


angular.module('app.controllers')

.controller('ClassIndexCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'

    ($scope, $rootScope, $routeParams) ->
      # Initial set of clazz data
      $scope.viewType = 'info'
      $scope.clazz = angular.copy($scope.openedClass)

      # For prevent updating when not opdate on one class number
      init_dow = $routeParams.weekDay
      init_clazz = $routeParams.classNum
      init_atom = $routeParams.atomClass

      # Update when change class on one line
      $rootScope.$on("openedClassUpdated", (e, dow, clazz, atom, dows=undefined)->
        if (dows and init_dow in dows and clazz is init_clazz) or not dows
          $scope.viewType = 'info'
          $scope.clazz = angular.copy($scope.openedClass)
      )
  ])