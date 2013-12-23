'use strict'


angular.module('app.controllers')

.controller('ClassTimerCtrl', [
    '$scope'
    '$timeout'

    ($scope, $timeout) ->
      # Get data
      start_time = $scope.clazz.time.start
      start_date = new Date($scope.clazz.activity.start)
      start_date.setHours(0)
      start_date.setSeconds(0)
      start_date.setMinutes(start_time)

      # Main update logic
      updateValues = ->
        diff = (start_date - new Date())
        if diff < 0
          $timeout.cancel(updateTimer)
          $scope.starts = yes
        else
          $scope.days = Math.floor((diff / 1000) / 60 / 60 / 24)
          $scope.hours = Math.floor((diff / 1000) / 60 / 60) - $scope.days * 24
          $scope.minutes = Math.floor((diff / 1000) / 60 ) - $scope.days * 24 * 60 - $scope.hours * 60
      updateValues()

      # Periodicaly update currents
      updateTimer = undefined
      updateCurrentsPeriodicaly = ->
        updateTimer = $timeout(->
          updateValues()
          updateCurrentsPeriodicaly()
        , 30000)
      updateCurrentsPeriodicaly()
      $scope.$on('$destroy', ->
        $timeout.cancel(updateTimer)
      )
  ])