angular.module('app.services')
.factory "Place", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'
    'Cachier'


    ($q, $http, localeStorage, config, $timeout, Cachier) ->
      search: (term, faculty = 'ИМКН', start=0, limit=15) ->
        # Get promise
        last_arg = arguments[arguments.length-1]
        if last_arg && angular.isFunction(last_arg.then)
          timeout = last_arg

        $http(
          timeout: timeout
          method: 'GET'
          url: "#{config.apiUrl}/place"
          params:
            cabinet: term
            faculty: faculty
            start: start
            limit: limit
            identifiers: 'true'
        )

  ]