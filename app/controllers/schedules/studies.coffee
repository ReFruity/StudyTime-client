angular.module('app.controllers')
.controller('SchedulesStudiesCtrl', [
    '$scope'
    '$rootScope'
    '$location'
    '$routeParams'
    'Schedule'
    '$timeout'

    ($scope, $rootScope, $location, $routeParams, Schedule, $timeout) ->
      # Date for filtering events and others
      currentDate = new Date()

      # Get schedule
      raw_schedule = undefined
      Schedule.get($routeParams.groupName).then(
        (sched) ->
          $rootScope.scheduleLoading = no
          raw_schedule = sched
          initOpenedClassDetails(sched.schedule)
          $scope.sched = sched.schedule
          $scope.timing = sched.timing
          $scope.last_update = sched.updated
          updateCurrents()
      , (reason) ->
        $rootScope.scheduleLoading = no
        if raw_schedule and raw_schedule.updated
          $scope.last_update = raw_schedule.updated
      , (cached_sched) ->
        console.log $scope
        $rootScope.scheduleLoading = no
        raw_schedule = cached_sched
        initOpenedClassDetails(cached_sched.schedule)
        $scope.sched = cached_sched.schedule
        $scope.timing = cached_sched.timing
        updateCurrents()
      )

      # When user goes to some class
      initOpenedClassDetails = (sched)->
        if $routeParams.weekDay and $routeParams.classNum
          $scope.openedClass = sched[$routeParams.weekDay][$routeParams.classNum][$routeParams.atomClass]
          $rootScope.$emit("openedClassUpdated")

      # Set current class and dow base on faculty timing
      updateCurrents = ->
        mins = currentDate.getHours() * 60 + currentDate.getMinutes()

        # Set current dow
        $scope.currentDow = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][currentDate.getDay()]

        # Set current class num
        $scope.currentClass = "1"
        greeter_count = 0
        for clazz in _.keys($scope.timing)
          if mins >= $scope.timing[clazz].start
            $scope.currentClass = clazz
            greeter_count++
        if greeter_count == $scope.timing.length
          $scope.currentClass = undefined

      # Update dow dates and current view data
      updateDowDates = ->
        $scope.dowDates = {}
        dows = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        now = new Date(currentDate)

        for day in [0..6]
          distance = day + 1 - now.getDay()
          now.setDate(now.getDate() + distance)
          $scope.dowDates[dows[day]] = new Date(now)
      updateDowDates()

      # Week parity updater
      updateWeekParity = ->
        d = new Date($scope.dowDates['Mon'])
        d.setHours(0, 0, 0)
        d.setDate(d.getDate() + 4 - (d.getDay() || 7))
        yearStart = new Date(d.getFullYear(), 0, 1)
        weekNo = Math.ceil(( ( (d - yearStart) / 86400000) + 1) / 7)
        $scope.currentParity = if weekNo % 2 == 0 then 'even' else 'odd'
      updateWeekParity()

      # Periodicaly update currents and dates every 5 minutes
      updateTimer = undefined
      updateCurrentsPeriodicaly = ->
        updateTimer = $timeout(->
          now = new Date()
          if now > currentDate
            updateScheduleForDate()

          updateCurrentsPeriodicaly()
        , 300000)
      updateCurrentsPeriodicaly()
      $scope.$on('$destroy', ->
        $timeout.cancel(updateTimer)
      )

      updateScheduleForDate = ->
        updateCurrents()
        updateDowDates()
        updateWeekParity()

      # Opend class details
      $scope.showDetails = (dow, clazz, atom) ->
        $scope.columnIndex = atom
        if $routeParams.weekDay is dow and $routeParams.classNum is clazz and $routeParams.atomClass is atom + ""
          $location.path('/' + $routeParams.groupName)
        else
          $location.path('/' + $routeParams.groupName + '/' + dow + '/' + clazz + '/' + atom)

      # Close details
      $scope.closeDetails = ->
        $location.path('/' + $routeParams.groupName)

      # Show next week
      $scope.nextWeek = ->
        now = new Date(currentDate)
        now.setDate(now.getDate() + 7)
        currentDate = now
        $scope.in_feature = true
        updateScheduleForDate()

      # Show previous week
      $scope.prevWeek = ->
        if $scope.in_feature
          real_now = new Date()
          now = new Date(currentDate)
          now.setDate(now.getDate() - 7)
          currentDate = now
          updateScheduleForDate()

          if now <= real_now
            $scope.in_feature = false
  ])