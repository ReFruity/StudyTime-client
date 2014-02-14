##
# This mixin component detects view type by
# width of the window, set it in "this.viewType" property
# and `forceUpdate()` the component on any view type change (window resize)
# View type can be set globally by setting 'global.viewType' property to
# 'mobile' or 'desktop'
#
Gator = require 'gator'
forceViewType = @viewType

windowWidth = ->
  w = window
  d = document
  e = d.documentElement
  g = d.getElementsByTagName('body')[0]
  return w.innerWidth or e.clientWidth or g.clientWidth

module.exports =
  componentWillMount: ->
    if forceViewType
      @viewType = forceViewType
    else if typeof window != 'undefined'
      init = true
      self = @
      updateViewType = ->
        oldViewType = self.viewType
        if windowWidth() >= 868
          self.viewType = "desktop"
        else
          self.viewType = "mobile"

        if init
          init = false
        else if oldViewType != self.viewType
          if not self.onViewTypeChange or self.onViewTypeChange()
            self.forceUpdate()
      updateViewType()

      Gator(window).on 'resize', updateViewType
    else
      @viewType = "desktop"
