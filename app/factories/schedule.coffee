angular.module('app.services')
.factory("Schedule", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'
    'Cachier'

    ($q, $http, ls, config, $timeout, Cachier) ->
      get: (group = undefined, type = 'study', faculty = 'ИМКН') ->
        Cachier("schedule.#{type}.#{faculty}.#{group}", (cache_value)->
          method: 'GET'
          url:  "#{config.apiUrl}/schedule/#{type}/#{faculty}/#{group}"
          params:
            if_updated_after: if cache_value then cache_value.updated else new Date(0).toISOString()
        )
  ])