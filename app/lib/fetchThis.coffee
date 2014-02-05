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


  methods =
    fetchThis: (options) ->
      @fetchActive = true
      options = {}  unless options
      success = options.success
      options.success = (model, resp, options) ->
        model.fetchActive = false
        success model, resp, options  if success
#        return
      @fetch options
      this

    fetch: (options) ->
      fetch = old_model::fetch.apply(this, arguments)
      model = this

      if fetch.fail
        fetch.fail ->
          model.fetchActive = false
          model.trigger "fetchError"
#          return
#      return

  Backbone.Model = Backbone.Model.extend methods
  Backbone.Collection = Backbone.Collection.extend methods

#  Backbone.Model
