'use strict'


angular.module('app.controllers')

.controller('ClassIndexCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'

    ($scope, $rootScope, $routeParams) ->
      # For prevent updating when not opdate on one class number
      init_dow = ""
      init_clazz = ""
      init_atom = ""
      updateClass = (dow, clazz, atom) ->
        # For prevent updating when not opdate on one class number
        init_dow = dow
        init_clazz = clazz
        init_atom = atom

        # Initial set of clazz data
        if init_dow and init_clazz and init_atom
          $scope.viewType = 'attachments'
          $scope.clazz = angular.copy($scope.sched[init_dow][init_clazz][init_atom])

      # Initial clazz update from route
      updateClass($routeParams.weekDay, $routeParams.classNum, $routeParams.atomClass)

      # Update class when history changed
      $scope.$on('$routeChangeSuccess', ->
        updateClass($routeParams.weekDay, $routeParams.classNum, $routeParams.atomClass)
      )
  ])