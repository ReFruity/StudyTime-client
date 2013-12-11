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
          raw_schedule = sched
          initOpenedClassDetails(sched.schedule)
          $scope.sched = sched.schedule
          $scope.timing = sched.timing
          $scope.last_update = sched.updated
          updateCurrents()
      , (reason) ->
        if raw_schedule and raw_schedule.updated
          $scope.last_update = raw_schedule.updated
      , (cached_sched) ->
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
        for clazz in _.keys($scope.timing)
          if mins >= $scope.timing[clazz].start and mins <= $scope.timing[clazz].end
            $scope.currentClass = clazz
            break

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
        d = new Date(currentDate)
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
          currentDate = new Date()
          updateCurrents()
          updateDowDates()
          updateCurrentsPeriodicaly()
          updateWeekParity()
        , 300000)
      updateCurrentsPeriodicaly()
      $scope.$on('$destroy', ->
        $timeout.cancel(updateTimer)
      )

      # Opend class details
      $scope.showDetails = (dow, clazz, atom, dows = undefined) ->
        $scope.columnIndex = atom
        if $routeParams.weekDay is dow and $routeParams.classNum is clazz and $routeParams.atomClass is atom + ""
          $location.path('/' + $routeParams.groupName)
        else
          $scope.openedClass = $scope.sched[dow][clazz][atom]
          $rootScope.$emit("openedClassUpdated", dow, clazz, atom, dows)
          $location.path('/' + $routeParams.groupName + '/' + dow + '/' + clazz + '/' + atom)
  ])