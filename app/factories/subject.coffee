angular.module('app.services')
.factory "Subject", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'
    'Cachier'

    ($q, $http, localeStorage, config, $timeout, Cachier) ->
      sign_upload: ->
        deferred = $q.defer()
        $timeout(->
          $http(
            method: 'POST'
            url: "#{config.apiUrl}/subject/"
          )
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