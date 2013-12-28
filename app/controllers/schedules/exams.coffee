angular.module('app.controllers')

.controller('SchedulesExamsCtrl', [
    '$scope'
    '$rootScope'
    'Schedule'
    '$routeParams'
    '$location'
    'eventEditorValues'
    'Event'

    ($scope, $rootScope, Schedule, $routeParams, $location, eventEditorValues, Event) ->
      $scope.parts = []

      # Update exams bounds if needed
      maybeUpdateBounds = (bounds, date) ->
        date = new Date(date)
        if date > bounds[1]
          bounds[1] = date
        if date < bounds[0]
          bounds[0] = date

      # Update schedule in scope
      raw_schedule = undefined
      $scope.sched_shared.last_update = 0
      updateSchedule = (sched) ->
        $scope.parts = []
        raw_schedule = sched
        $scope.timing = sched.timing
        $scope.sched = sched.schedule
        now = new Date()

        # Process schedule
        exams = []
        tests = []
        exams_bounds = [new Date(3000, 1, 1), new Date(0)]
        tests_bounds = [new Date(3000, 1, 1), new Date(0)]

        for dow of sched.schedule
          for clazz of sched.schedule[dow]
            for atom_index in [0...sched.schedule[dow][clazz].length]
              atom = sched.schedule[dow][clazz][atom_index]
              atom.index = atom_index
              atom.dow = dow
              atom.number = clazz
              atom.group =
                name: $scope.group.name
                object: $scope.group._id
              start_date = new Date(atom.activity.start)
              start_date.setHours(0)
              start_date.setSeconds(0)
              start_date.setMinutes(atom.time.start)
              atom.started = now > start_date
              console.log now
              console.log start_date

              if atom.type == 'exam' or atom.type == 'consult'
                exams.push(atom)
                maybeUpdateBounds(exams_bounds, atom.activity.start)
              else
                tests.push(atom)
                maybeUpdateBounds(tests_bounds, atom.activity.start)

        # Add session parts
        if tests.length > 0
          $scope.tests_bounds = tests_bounds
          $scope.tests = tests
          $scope.parts.push({type:'tests', name:'Зачеты'})

        if exams.length > 0
          $scope.exams_bounds = exams_bounds
          $scope.exams = exams
          $scope.parts.push({type:'exams', name:'Экзамены'})

      # Some thing when error loading scedule
      processError = ->
        if raw_schedule and raw_schedule.updated
          $scope.sched_shared.last_update = raw_schedule.updated
        else
          $scope.sched_shared.last_update = new Date()

      # Load schedule from server
      requestSchedule = ->
        Schedule.get($routeParams.groupName, 'exam').then((sched)->
          updateSchedule(sched)
          $scope.sched_shared.last_update = sched.updated
        , processError, updateSchedule)
      requestSchedule()

      # Change event
      $scope.changeEvent = (evt) ->
        eventEditorValues.event = angular.copy(evt)

      $scope.cancelEvent = (evt, part) ->
        part.splice(part.indexOf(evt), 1);
        Event.cancel(evt._id, evt.activity.start, evt.activity.end)

      # Update schedule on event
      $scope.$on('updateSchedule', (_, event)->
        requestSchedule()
      )
  ])