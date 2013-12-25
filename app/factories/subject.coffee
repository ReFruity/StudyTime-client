angular.module('app.services')
.factory "Subject", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'
    'Cachier'

    ($q, $http, localeStorage, config, $timeout, Cachier) ->
      attachments: (subject_id, faculty='ИМКН', types=undefined, start=0, limit=50)->
        Cachier("subj.#{subject_id}.#{faculty}.#{types}.#{start}.#{limit}.attachments", (cache_value)->
          method: 'GET'
          url: "#{config.apiUrl}/subject/#{subject_id}/attachment"
          params:
            if_updated_after: if cache_value and cache_value.updated then cache_value.updated else new Date(0).toISOString()
            faculty: faculty
            types: types
            start: start
            limit: limit
        )

      upload_done: (subject_id, file)->
        $http(
          method: 'POST'
          url: "#{config.apiUrl}/subject/#{subject_id}/attachment"
          data: file
        )

      sign_upload: (subject_id)->
        $http(
          method: 'POST'
          url: "#{config.apiUrl}/subject/#{subject_id}/attachment/sign"
        )

      search: (term, start=0, limit=15) ->
        # Get promise
        last_arg = arguments[arguments.length-1]
        if last_arg && angular.isFunction(last_arg.then)
          timeout = last_arg

        $http(
          timeout: timeout
          method: 'GET'
          url: "#{config.apiUrl}/subject"
          params:
            name: term
            start: start
            limit: limit
            identifiers: 'true'
        )
  ]