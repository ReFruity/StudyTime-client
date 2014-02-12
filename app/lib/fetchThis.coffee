# This backbone.model modification adds
# useful .fetchThis() method, returning 'this'
# instead jqXHR
((factory) ->
  if typeof define is "function" and define.amd

    # Register as an AMD module if available...
    define [
      "underscore"
      "backbone"
    ], factory
  else if typeof exports isnt "undefined"
    _ = undefined
    backbone = undefined
    try
      _ = require("underscore")
    try
      backbone = require("backbone")
    module.exports = factory(_, backbone)
  else

    # Browser globals for the unenlightened...
    factory _, Backbone
  return
) (_, Backbone) ->
  old_model = Backbone.Model
  old_coll = Backbone.Collection

  methods = (old)->
    fetchThis: (options) ->
      @fetch options
      this

    fetch: (options) ->
      fetch = old::fetch.apply(this, arguments)
      model = this
      if fetch.fail
        fetch.fail ->
          model.trigger "fetchError"
        fetch.done ->
          model.trigger "fetchDone"

  Backbone.Model = Backbone.Model.extend methods(old_model)
  Backbone.Collection = Backbone.Collection.extend methods(old_coll)