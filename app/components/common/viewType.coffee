# If view type set globally (in node.js, for example)
forceViewType = @viewType

module.exports =
  componentWillMount: ->
    if forceViewType
      @viewType = forceViewType
    else if(window)
      init = true
      self = @
      updateViewType = ->
        oldViewType = self.viewType
        if $(window).width() >= 768
          self.viewType = "desktop"
        else
          self.viewType = "mobile"

        if init
          init = false
        else if oldViewType != self.viewType
          self.forceUpdate()
      updateViewType()

      $(window).on 'resize', updateViewType
    else
      @viewType = "desktop"
