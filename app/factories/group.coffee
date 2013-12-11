angular.module('app.services')
.factory "Group", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'


    ($q, $http, localeStorage, config, $timeout) ->
      lastOpened:
        get: ->
          localeStorage.get('group.lasteOpened')
        set: (groupName) ->
          localeStorage.add('group.lasteOpened', groupName)

      get: (faculty = 'ИМКН') ->
        deferred = $q.defer()

        $timeout(->
          group_idnt = "group.#{faculty}"

          # Load schedule from cache
          cache_value = localeStorage.get(group_idnt)
          cache_value = if cache_value then angular.fromJson(cache_value) else undefined
          deferred.notify(cache_value) if cache_value

          # Update cache
          $http(
            method: 'GET'
            url: "#{config.apiUrl}/group"
            params:
              faculty: faculty
          )
          .success (data)->
              # Send data to user
              if data.length == 0
                deferred.reject false
              else
                localeStorage.add group_idnt, angular.toJson(data)
                deferred.resolve data
          .error (data) ->
            deferred.reject false
        )

        deferred.promise
  ]