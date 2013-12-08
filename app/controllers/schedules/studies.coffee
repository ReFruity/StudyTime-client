angular.module('app.controllers')
.controller('SchedulesStudiesCtrl', [
    '$scope'
    '$rootScope'
    '$location'
    '$routeParams'
    'Schedule'

    ($scope, $rootScope, $location, $routeParams, Schedule) ->
      Schedule.get($routeParams.groupName).then(
        (sched) ->
          initOpenedClassDetails(sched.schedule)
          $scope.sched = sched.schedule
          $scope.timing = sched.timing
          $scope.$parent.$parent.last_update = sched.updated
          console.log($scope.sched)
      , (reason) ->
          console.log(reason)
      , (cached_sched) ->
          initOpenedClassDetails(cached_sched.schedule)
          $scope.sched = cached_sched.schedule
          $scope.timing = cached_sched.timing
          $scope.$parent.$parent.last_update = cached_sched.updated
      )

      initOpenedClassDetails = (sched)->
        if $routeParams.weekDay and $routeParams.classNum
          $scope.openedClass = sched[$routeParams.weekDay][$routeParams.classNum][0]
          $rootScope.$emit("openedClassUpdated")

      # Opend class details
      $scope.showDetails = (dow, clazz, atom, dows=undefined) ->
        if $routeParams.weekDay is dow and $routeParams.classNum is clazz and $routeParams.atomClass is atom+""
          $location.path('/' + $routeParams.groupName)
        else
          $scope.openedClass = $scope.sched[dow][clazz][atom]
          $rootScope.$emit("openedClassUpdated", dow, clazz, atom, dows)
          $location.path('/' + $routeParams.groupName + '/' + dow + '/' + clazz + '/' + atom)
  ])