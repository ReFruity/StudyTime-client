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
