angular.module('app.services')
.factory("Schedule", [
    '$q'
    '$http'
    'localStorageService'
    'config'
    '$timeout'
    'Cachier'

    ($q, $http, ls, config, $timeout, Cachier) ->
      filter: (sched, start, end, filter = undefined) ->
        filtered_events = 0
        new_sched = {}
        for dow of sched
          new_sched[dow] = {}
          for clazz of sched[dow]
            new_sched[dow][clazz] = []
            filtered_in_cell = 0
            for atom in sched[dow][clazz]
              act =
                start: new Date(atom.activity.start)
                end: new Date(atom.activity.end)

              if (act.start <= start < act.end or act.start < end <= act.end or (start <= act.start and end >= act.end)) and (not filter or filter(atom, filtered_in_cell, dow, clazz))
                filtered_events += 1
                filtered_in_cell += 1
                new_sched[dow][clazz].push atom

        return if filtered_events > 0 then new_sched else undefined

      get: (group = undefined, type = 'study', faculty = 'ИМКН') ->
        Cachier("schedule.#{type}.#{faculty}.#{group}", (cache_value)->
          method: 'GET'
          url: "#{config.apiUrl}/schedule/#{type}/#{faculty}" + (if group then "/#{group}" else "")
          params:
            if_updated_after: if cache_value then cache_value.updated else new Date(0).toISOString()
        )
  ])