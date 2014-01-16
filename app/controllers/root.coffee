class RootSubrouter extends Backbone.SubRoute
  routes:
    "": "index"

  initialize: ->
    ""

  index: ->
    console.log "root index"

module.exports = RootSubrouter