React = require 'react'

module.exports =
  __syncedModels: []

  componentDidMount: ->
    # Whenever there may be a change in the Backbone data, trigger a reconcile.
    this.getBackboneModels().forEach(this.injectModel, this)

  componentWillUnmount: ->
    # Ensure that we clean up any dangling references when the component is
    # destroyed.
    this.__syncedModels.forEach (model) ->
      model.off(null, model.__updater, this);
    , this

  injectModel: (model) ->
    if !~this.__syncedModels.indexOf(model) and this._lifeCycleState == 'MOUNTED'
      updater = this.forceUpdate.bind(this, null);
      model.__updater = updater;
      model.on('add change remove fetchError', updater, this);

  bindTo: (model, key) ->
    value: model.get(key)
    requestChange: ((value) ->
      model.set(key, value)
    ).bind(this)