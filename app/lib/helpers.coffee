# Sugar for requiring components
window.requireComponent = (path)->
  require("components/#{path}")