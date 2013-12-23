angular.module('app.services')
.factory "Event", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'
    'Cachier'

    ($q, $http, localeStorage, config, $timeout, Cachier) ->
      update: (id, event) ->
        $http(
          method: 'POST'
          url: "#{config.apiUrl}/event/#{id}"
          data: event
        )

      create: (event) ->
        $http.post("#{config.apiUrl}/event", event)

      list: (types, group = undefined, faculty = 'ИМКН') ->
        Cachier("event.list.#{faculty}.#{group}.#{types.join('.')}", (cache_value)->
          method: 'GET'
          url: "#{config.apiUrl}/event"
          params:
            faculty: faculty
            group: group
            types: types
            if_updated_after: if cache_value and cache_value.updated then cache_value.updated else new Date(0).toISOString()
        )
  ]