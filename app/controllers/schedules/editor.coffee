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
        $scope.processing = yes
        $scope.error = no

        # Replace identifiers to objectId list
        event = angular.copy($scope.values.event)
        event.place = identiifiersToObjectIds(event.place)
        event.professor = identiifiersToObjectIds(event.professor)
        event.subject = identiifiersToObjectIds(event.subject)
        event.group = identiifiersToObjectIds(event.group)

        # Update time if not set
        if event.activity and event.activity.start
          st_date = new Date(event.activity.start)
          if not event.dow
            event.dow = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][st_date.getDay()]
          if (not event.time or not event.time.start) and not event.number
            event.time = start: st_date.getHours() * 60 + st_date.getMinutes()

        # Update existing event
        if event._id
          id = event._id
          event._id = undefined
          Event.update(id, event).success((data)->
            $scope.processing = no
          ).error((error)->
            $scope.processing = no
            $scope.error = yes
          )

        # Create new event
        else
          Event.create(event).success((data)->
            $scope.processing = no
          ).error((error)->
            $scope.processing = no
            $scope.error = yes
          )

      # Convert lis of {name:.., object:...} to list of [object, object...]
      identiifiersToObjectIds = (idnts, is_array=yes)->
        if not idnts
          return undefined
        if angular.isArray(idnts)
          return (idnt.object for idnt in idnts).join(", ")
        if angular.isObject(idnts) and idnts.object
          return idnts.object
        else
          return idnts
  ])