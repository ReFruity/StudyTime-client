angular.module('app.controllers')

.controller('PlacesIndexCtrl', [
    '$scope'
    '$rootScope'
    '$location'
    '$routeParams'
    'Schedule'
    '$timeout'
    '$q'

    ($scope, $rootScope, $location, $routeParams, Schedule, $timeout, $q) ->
      # Initial update schedule
      updateSchedule = ->
        $scope.updated = undefined
        Schedule.get($routeParams.groupName, 'place').then(onNewData, onNoData, onCachedData)

      # Init schedule from cache
      cached_data = undefined
      onCachedData = (data)->
        cached_data = data
        $scope.timing = data.timing
        $scope.tz = data.tz
        $scope.places = data.places

      # Update cached values by new data
      onNewData = (data)->
        $scope.updated = data.updated
        onCachedData(data)

      # When no data returned
      onNoData = (data)->
        $scope.updated = if cached_data then cached_data.updated else new Date()

      # Filter schedule for showing events for current week
      # Also remove duplicate places from one cell and
      # filter places by features
      $scope.filterSchedule = (dowDates)->
        $timeout ->
          tmp_check = 'Mon':{}, 'Tue':{}, 'Wed':{}, 'Thu':{}, 'Fri':{}, 'Sat':{}, 'Sun':{}
          $scope.sched = Schedule.filter(cached_data.schedule, dowDates['Mon'], dowDates['Sun'], (e, i, dow, clazz)->
            if i < 10 and (not tmp_check[dow][clazz] or not tmp_check[dow][clazz][e.object]) # and $scope.places[e.object].features.opened
              if not tmp_check[dow][clazz]
                tmp_check[dow][clazz] = {}
              tmp_check[dow][clazz][e.object] = yes
              return yes
            return no
          )

      # Start loading schedule
      updateSchedule()
  ])