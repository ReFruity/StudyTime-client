angular.module('app.controllers')
.controller('SchedulesStudiesCtrl', [
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
        Schedule.get($routeParams.groupName).then(onNewData, onNoData, onCachedData)

      # Init schedule from cache
      cached_data = undefined
      onCachedData = (data)->
        cached_data = data
        $scope.timing = data.timing
        $scope.tz = data.tz
        $scope.exams = data.exams
        updatePrecomputed()

      # Update cached values by new data
      onNewData = (data)->
        $scope.updated = data.updated
        onCachedData(data)

      # When no data returned
      onNoData = (data)->
        $scope.updated = if cached_data then cached_data.updated else new Date()

      # Set classDetails by coordinates from url
      setOpenedClass = ->
        try
          if $routeParams.weekDay
            $scope.classDetails = $scope.sched[$routeParams.weekDay][$routeParams.classNum][$routeParams.atomClass]

      # Update precomputed view values
      currentDate = new Date()
      updatePrecomputed = ->
        computeCurrentClass()
        computeDowDates()
        computeWeekParity()
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

      # Compute current week parity
      computeWeekParity = ->
        d = new Date($scope.dowDates['Mon'])
        d.setHours(0, 0, 0)
        d.setDate(d.getDate() + 4 - (d.getDay() || 7))
        yearStart = new Date(d.getFullYear(), 0, 1)
        weekNo = Math.ceil(( ( (d - yearStart) / 86400000) + 1) / 7)
        $scope.currentParity = if weekNo % 2 == 0 then 'even' else 'odd'

      # Filter schedule for showing events for current week
      filterSchedule = ->
        updated = $scope.updated
        $scope.updated = undefined
        $timeout ->
          $scope.sched = Schedule.filter(cached_data.schedule, $scope.dowDates['Mon'], $scope.dowDates['Sun'])
          $scope.updated = updated
          setOpenedClass()

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

      # Show next week
      $scope.nextWeek = ->
        now = new Date(currentDate)
        now.setDate(now.getDate() + 7)
        currentDate = now
        $scope.in_feature = true
        updatePrecomputed()

      # Show previous week
      $scope.prevWeek = ->
        if $scope.in_feature
          real_now = new Date()
          now = new Date(currentDate)
          now.setDate(now.getDate() - 7)
          currentDate = now
          updatePrecomputed()

          if now <= real_now
            $scope.in_feature = false

      # Open/Close class details
      $scope.classDetails = {}
      $scope.$on('$routeChangeSuccess', setOpenedClass)
      $scope.closeDetails = ->
        $scope.classDetails = undefined
        $location.path('/' + $routeParams.groupName)
      $scope.showDetails = (dow, clazz, atom) ->
        if $routeParams.weekDay is dow and $routeParams.classNum is clazz and $routeParams.atomClass is atom + ""
          $scope.closeDetails()
        else
          $location.path('/' + $routeParams.groupName + '/' + dow + '/' + clazz + '/' + atom)

      # Start loading schedule
      updateSchedule()
  ])