angular.module('app.services')
.factory("Schedule", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'

    ($q, $http, ls, config, $timeout) ->
      get: (group = undefined, type = 'study', faculty = 'ИМКН') ->
        # Create defer
        deferred = $q.defer()

        # Run async because cache loading must
        # be completed after caller set notification
        # handler on the promise
        $timeout(->
          sched_idnt = "schedule.#{type}.#{faculty}.#{group}"

          # Load schedule from cache
          cache_value = ls.get(sched_idnt)
          cache_value = if cache_value then angular.fromJson(cache_value) else undefined
          if cache_value
            deferred.notify(cache_value)

          # Update cache
          $http(
            method: 'GET'
            url:  "#{config.apiUrl}/schedule/#{type}/#{faculty}/#{group}"
            params:
              if_updated_after: if cache_value then cache_value.updated else new Date(0).toISOString()
          )
          .success((data)->
              # Send data to user
              if data.length == 0
                  deferred.reject(false)
              else
                ls.add(sched_idnt, angular.toJson(data))
                deferred.resolve(data)
            )
          .error((data)->
              deferred.reject(false)
            )
        )

        # Return promise syncronously
        deferred.promise
  ])