angular.module('app.controllers')

.controller('SchedulesExamsCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'
    '$location'
    'eventEditorValues'
    'Event'

    ($scope, $rootScope, $routeParams, $location, eventEditorValues, Event) ->
      # Initial update schedule
      $scope.exams = 1
      updateSchedule = ->
        $scope.updated = undefined
        Event.list(['exam', 'test', 'consult'], $routeParams.groupName).then(onNewData, onNoData, onCachedData)

      # Init schedule from cache
      cached_data = undefined
      onCachedData = (data)->
        cached_data = data
        computeExamParts()
        setOpenedClass()

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
            $scope.classDetails = cached_data.events[$routeParams.weekDay]

      # Separate events by type
      computeExamParts = ->
        $scope.exam_parts = []
        now = new Date()
        type_map =
          exam: {events: [], bounds: [new Date(3000, 1, 1), new Date(0)], type: 'exam'}
          test: {events: [], bounds: [new Date(3000, 1, 1), new Date(0)], type: 'test'}

        # Separate and update bounds
        for i in [0...cached_data.events.length]
          e = cached_data.events[i]
          e.started = now > new Date(e.activity.start)
          e.index = i
          type = if e.type == 'exam' or e.type == 'consult' then 'exam' else e.type
          type_map[type].events.push e
          maybeUpdateBounds type_map[type].bounds, new Date(e.activity.start)

        # Sort by activity.start
        for t of type_map
          type_map[t].events = type_map[t].events.sort (a, b) ->
            new Date(a.activity.start) - new Date(b.activity.start)

        # Add to result array sorted
        for t in ['test', 'exam']
          if type_map[t].events.length > 0
            $scope.exam_parts.push type_map[t]

      # Update exams bounds if needed
      maybeUpdateBounds = (bounds, date) ->
        date = new Date(date)
        if date > bounds[1]
          bounds[1] = date
        if date < bounds[0]
          bounds[0] = date

      # Open/Close class details
      $scope.classDetails = {}
      $scope.$on('$routeChangeSuccess', setOpenedClass)
      $scope.closeDetails = ->
        $scope.classDetails = undefined
        $location.path('/' + $routeParams.groupName)
      $scope.showDetails = (event_index) ->
        if $routeParams.weekDay is event_index+""
          $scope.closeDetails()
        else
          $location.path('/' + $routeParams.groupName + '/' + event_index)

      # Start schedule loading
      updateSchedule()
  ])