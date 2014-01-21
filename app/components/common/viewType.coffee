##
# This mixin component detects view type by
# width of the window, set it in "this.viewType" property
# and `forceUpdate()` the component on any view type change (window resize)
# View type can be set globally by setting 'global.viewType' property to
# 'mobile' or 'desktop'
#
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
