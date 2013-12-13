angular.module('app.services')
.factory "Cachier", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'


    ($q, $http, localeStorage, config, $timeout) ->
      (cache_idnt, http_req) ->
        deferred = $q.defer()
        $timeout(->
          # Load value from cache
          cache_value = localeStorage.get(cache_idnt)
          cache_value = if cache_value then angular.fromJson(cache_value) else undefined
          deferred.notify(cache_value) if cache_value

          # Make http_req if it's a function
          if angular.isFunction(http_req)
            http_req = http_req(cache_value)

          # Update cache
          $http(http_req)
          .success (data)->
              # Send data to user
              if data.length == 0
                deferred.reject false
              else
                localeStorage.add cache_idnt, angular.toJson(data)
                deferred.resolve data
          .error (data) ->
            deferred.reject false
        )
        deferred.promise
  ]