angular.module('app.controllers')

.controller('SchedulesExamsCtrl', [
    '$scope'
    '$rootScope'

    ($scope, $rootScope) ->
      $rootScope.scheduleLoading = no
  ])