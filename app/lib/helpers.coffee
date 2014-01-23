##
# Require sugar
#
@requireComponent = (path)->
  require("components/#{path}")

@requireModels = (models...)->
  _requireList("models", models)

@requireCollections = (collections...)->
  _requireList("collections", collections)

@requireComponents = (path, components...)->
  _requireList("components/#{path}", components)

_requireList = (path, components)->
  # Remove trailing slashes
  path = path.replace(/\/+$/, "")
  path = path.replace(/^\/+/, "")

  # Get components
  _.object([a, require("#{path}/#{a}")] for a in components)

##
# Date helpers
#
Date::getWeekBounds = ->
  bw = {0: 6, 1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5}
  left = new Date(@)
  left.setDate(left.getDate() - bw[left.getDay()])
  right = new Date(left)
  right.setDate(left.getDate() + 6)
  left.setHours(0,0,0,0,0)
  right.setHours(0,0,0,0,0)
  [left, right]