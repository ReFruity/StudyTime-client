angular.module('app.services')
.factory "Group", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'
    'Cachier'


    ($q, $http, localeStorage, config, $timeout, Cachier) ->
      lastOpened:
        get: ->
          localeStorage.get('group.lasteOpened')
        set: (groupName) ->
          localeStorage.add('group.lasteOpened', groupName)

      lastShowedState:
        get: (group_name) ->
          localeStorage.get("group.#{group_name}.lasteShowedState")
        set: (group_name, state) ->
          localeStorage.add("group.#{group_name}.lasteShowedState", state)

      get: (name_or_id) ->
        Cachier("group.obj.#{name_or_id}", (cache_value)->
          method: 'GET'
          url: "#{config.apiUrl}/group/#{name_or_id}"
          params:
            if_updated_after: if cache_value and cache_value.updated then cache_value.updated else new Date(0).toISOString()
        )

      list: (faculty = 'ИМКН') ->
        Cachier("group.list.#{faculty}", (cache_value)->
          method: 'GET'
          url: "#{config.apiUrl}/group/compiled"
          params:
            faculty: faculty
            if_updated_after: if cache_value and cache_value.updated then cache_value.updated else new Date(0).toISOString()
        )

      search: (term, faculty = 'ИМКН', start=0, limit=15) ->
        # Get promise
        last_arg = arguments[arguments.length-1]
        if last_arg && angular.isFunction(last_arg.then)
          timeout = last_arg

        $http(
          timeout: timeout
          method: 'GET'
          url: "#{config.apiUrl}/group"
          params:
            name: term
            faculty: faculty
            start: start
            limit: limit
            identifiers: 'true'
        )

  ]