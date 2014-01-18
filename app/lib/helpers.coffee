# Sugar for requiring components
window.requireComponent = (path)->
  require("components/#{path}")

# Sugar for getting set of components
window.requireComponents = (path, components...)->
  # Remove trailing slashes
  path = path.replace(/\/+$/, "")
  path = path.replace(/^\/+/, "")

  # Get components
  _.object([a, require("components/#{path}/#{a}")] for a in components)
