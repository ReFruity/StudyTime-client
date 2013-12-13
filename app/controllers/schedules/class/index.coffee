'use strict'


angular.module('app.controllers')

.controller('ClassIndexCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'

    ($scope, $rootScope, $routeParams) ->
      # For prevent updating when not opdate on one class number
      init_dow = $routeParams.weekDay
      init_clazz = $routeParams.classNum
      init_atom = $routeParams.atomClass

      # Initial set of clazz data
      $scope.viewType = 'info'
      $scope.clazz = angular.copy($scope.sched[init_dow][init_clazz][init_atom])

      # Update when change class on one line
      $scope.$on("openedClassUpdated", (e, dow, clazz, atom, dows=undefined)->
        if (dows and init_dow in dows and clazz is init_clazz) or not dows
          $scope.viewType = 'info'
          $scope.clazz = angular.copy($scope.sched[dow][clazz][atom])
      )

      # Update class when history changed
      $scope.$on('$routeChangeSuccess', ->
        # For prevent updating when not opdate on one class number
        init_dow = $routeParams.weekDay
        init_clazz = $routeParams.classNum
        init_atom = $routeParams.atomClass

        # Initial set of clazz data
        if init_dow and init_clazz and init_atom
          $scope.viewType = 'info'
          $scope.clazz = angular.copy($scope.sched[init_dow][init_clazz][init_atom])
      )
  ])