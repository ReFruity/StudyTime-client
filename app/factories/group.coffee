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
        Cachier("group.#{name_or_id}",
          method: 'GET'
          url: "#{config.apiUrl}/group/#{name_or_id}"
        )

      list: (faculty = 'ИМКН') ->
        Cachier("group.#{faculty}",
          method: 'GET'
          url: "#{config.apiUrl}/group"
          params:
            faculty: faculty
        )
  ]