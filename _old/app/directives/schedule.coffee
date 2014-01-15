angular.module('app.directives')
.directive "schedule", ["$timeout", ($timeout) ->
    content = undefined

    restrict: "E"
    replcae: yes

    templateUrl: (elem, attrs) ->
      content = elem[0].innerHTML
      if attrs.mobile != undefined
        return "app/partials/common/schedule-mobile.jade"
      else
        return "app/partials/common/schedule-desktop.jade"

    scope:
      timing: "="
      update: "="
      currentDate: "="
      dowDates: "="
      sched: "="

    controller: ['$scope', '$routeParams', ($scope, $routeParams) ->
      $scope.$routeParams = $routeParams
      if not $scope.currentDate
        $scope.currentDate = new Date()

      # Update precomputed view values
      updatePrecomputed = ->
        if $scope.timing and $scope.currentDate
          computeCurrentClass()
          computeDowDates()
          computeWeekParity()
          filterSchedule()

      # Compute current class value
      computeCurrentClass = ->
        $scope.currentDow = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][$scope.currentDate.getDay()]
        $scope.currentClass = "1"

        # Approximate current class
        mins = $scope.currentDate.getHours() * 60 + $scope.currentDate.getMinutes()
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
        now = new Date($scope.currentDate)
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
        if $scope.update
          $scope.update($scope.dowDates)

      # Periodicaly update precomputed values
      updateTimer = undefined
      updatePrecomputedPeriodicaly = ->
        updateTimer = $timeout(->
          now = new Date()
          if now > $scope.currentDate
            updatePrecomputed()
          updatePrecomputedPeriodicaly()
        , 300000)
      updatePrecomputedPeriodicaly()
      $scope.$on('$destroy', ->
        $timeout.cancel(updateTimer)
      )

      # Update on change timing or current date
      $scope.$watch('timing', updatePrecomputed)
      $scope.$watch('currentDate', updatePrecomputed)
      return this
    ]
    link: ($scope, element, attrs) ->
      $scope.$$content = content
  ]

angular.module('app.directives')
.directive "atom", ['$compile', '$timeout', ($compile, $timeout)->
    restrict: "E"
    require: "^schedule"
    replace: yes
    template: "<div></div>"
    link: ($scope, element, attrs) ->
      if $scope.$$content
        update = ->
          $timeout(->
            element.contents().remove()
            if $scope.sched[$scope.dow] and $scope.sched[$scope.dow][$scope.class]
              for atom in $scope.sched[$scope.dow][$scope.class]
                new_scope = $scope.$new()
                new_scope.atom = atom
                new_element = $compile("<div>#{$scope.$$content}</div>")(new_scope)
                element.append(new_element)
          )

        $scope.$watch('sched', (val)->
          update()
        )
  ]

