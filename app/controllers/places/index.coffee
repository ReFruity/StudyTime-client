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
        updatePrecomputed()

      # Update cached values by new data
      onNewData = (data)->
        $scope.updated = data.updated
        onCachedData(data)

      # When no data returned
      onNoData = (data)->
        $scope.updated = if cached_data then cached_data.updated else new Date()

      # Update precomputed view values
      currentDate = new Date()
      updatePrecomputed = ->
        computeCurrentClass()
        computeDowDates()
        filterSchedule()

      # Compute current class value
      computeCurrentClass = ->
        $scope.currentDow = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][currentDate.getDay()]
        $scope.currentClass = "1"

        # Approximate current class
        mins = currentDate.getHours() * 60 + currentDate.getMinutes()
        greeter_count = 0
        for clazz in _.keys($scope.timing)
          if mins >= $scope.timing[clazz].start
            $scope.currentClass = clazz
            greeter_count++
        if greeter_count == $scope.timing.length
          $scope.currentClass = undefined

      # Compute dates of days of week
      computeDowDates = ->
        $scope.dowDates = {}
        dows = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        now = new Date(currentDate)
        for day in [0..6]
          distance = day + 1 - now.getDay()
          now.setDate(now.getDate() + distance)
          $scope.dowDates[dows[day]] = new Date(now)

      # Filter schedule for showing events for current week
      # Also remove duplicate places from one cell and
      # filter places by features
      filterSchedule = ->
        updated = $scope.updated
        $scope.updated = undefined
        $timeout ->
          tmp_check = 'Mon':{}, 'Tue':{}, 'Wed':{}, 'Thu':{}, 'Fri':{}, 'Sat':{}, 'Sun':{}
          $scope.sched = Schedule.filter(cached_data.schedule, $scope.dowDates['Mon'], $scope.dowDates['Sun'], (e, i, dow, clazz)->
            if i < 7 and (not tmp_check[dow][clazz] or not tmp_check[dow][clazz][e.object]) # and $scope.places[e.object].features.opened
              if not tmp_check[dow][clazz]
                tmp_check[dow][clazz] = {}
              tmp_check[dow][clazz][e.object] = yes
              return yes
            return no
          )
          $scope.updated = updated

      # Periodicaly update precomputed values
      updateTimer = undefined
      updatePrecomputedPeriodicaly = ->
        updateTimer = $timeout(->
          now = new Date()
          if now > currentDate
            updatePrecomputed()
          updatePrecomputedPeriodicaly()
        , 300000)
      updatePrecomputedPeriodicaly()
      $scope.$on('$destroy', ->
        $timeout.cancel(updateTimer)
      )

      # Start loading schedule
      updateSchedule()
  ])