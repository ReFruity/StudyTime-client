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

      # Filter schedule for showing events for current week
      $scope.filterSchedule = (dowDates)->
        $timeout ->
          $scope.sched = Schedule.filter(cached_data.schedule, dowDates['Mon'], dowDates['Sun'])
          if not $scope.sched
            $scope.sched = {}
          setOpenedClass()

      # Show next week
      $scope.nextWeek = ->
        now = new Date($scope.currentDate)
        now.setDate(now.getDate() + 7)
        $scope.currentDate = now
        $scope.in_feature = true

      # Show previous week
      $scope.prevWeek = ->
        if $scope.in_feature
          real_now = new Date()
          now = new Date($scope.currentDate)
          now.setDate(now.getDate() - 7)
          $scope.currentDate = now
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
      $scope.currentDate = new Date()
      updateSchedule()
  ])