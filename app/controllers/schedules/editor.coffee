angular.module('app.controllers')
.value('eventEditorValues', {event: undefined})
.controller('SchedulesEditorCtrl', [
    '$scope'
    '$rootScope'
    'Event'
    'eventEditorValues'

    ($scope, $rootScope, Event, eventEditorValues) ->
      # Set cached values
      $scope.values = eventEditorValues

      # Listen on event changing request
      $scope.$on('changeEvent', (_, evt)->
        $scope.values.event = angular.copy(evt)
      )

      # Clear any event values
      $scope.clear = ->
        $scope.values.event = undefined

      # Create or update event
      $scope.makeChanges = ->
        # Update existing event
        if $scope.values.event._id
          id = $scope.values.event._id
          $scope.values.event._id = undefined
          Event.update(id, $scope.values.event)

        # Create new event
        else
          Event.create($scope.values.event)
  ])