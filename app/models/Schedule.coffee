config = require 'config'

ScheduleModel = Backbone.DeepModel.extend
  sync: Backbone.cachingSync(Backbone.sync, 'schedule')

  # Get default bounds
  defaults:
    bounds: new Date().getWeekBounds()

  # Schedule need to have some id for caching
  initialize: ->
    @id = "#{@get('type')}#{@get('faculty')}#{@get('group')}"

  url: ->
      "#{config.apiUrl}/schedule/#{@get('type')}/#{@get('faculty')}" + (if @has('group') then "/#{@get('group')}" else "")

  # Catch set of schedule for filtering atoms
  # in bounds
  set: (attributes, options) ->
    if _.isString(attributes) and attributes == "schedule"
      Backbone.Model::set.apply(this, ["schedule", @filterBounds(options)])
    else if _.isObject(attributes) and attributes.schedule
      attributes.schedule = @filterBounds(attributes.schedule)
      Backbone.Model::set.apply(this, [attributes, options])
    else
      Backbone.Model::set.apply(this, arguments)

  getBounds: (date) ->
    bw = {0: 6, 1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5}
    left = new Date(date)
    left.setDate(left.getDate() - bw[left.getDay()])
    right = new Date(left)
    right.setDate(left.getDate() + 6)
    left:left
    right:right

  filterBounds: (sched)->
    # Save original schedule
    @originalSched = sched

    # Filter events
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

    return if filtered_events > 0 then new_sched else {}

  _placeSchedFilter: ->


module.exports = ScheduleModel