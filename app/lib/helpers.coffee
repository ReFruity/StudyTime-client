##
# Date helpers
#
Date::getWeekBounds = ->
  bw = {0: 6, 1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5}
  left = new Date(@)
  left.setDate(left.getDate() - bw[left.getDay()])
  right = new Date(left)
  right.setDate(left.getDate() + 6)
  left.setHours(0,0,0,0,0)
  right.setHours(0,0,0,0,0)
  [left, right]

##
# String helpers
#
if not String::trim
  String::trim = ->
    @replace(/^\s+|\s+$/g, '')

scrollToTopInProgress = false
module.exports =
  findPos: (obj) ->
    curleft = 0
    curtop = 0;
    if obj.offsetParent
        curleft = obj.offsetLeft
        curtop = obj.offsetTop
        while obj = obj.offsetParent
            curleft += obj.offsetLeft
            curtop += obj.offsetTop

    return [curleft, curtop]

  scrollTop: (position) ->
    targetY = position or 0
    initialY = document.body.scrollTop
    lastY = initialY
    delta = targetY - initialY
    speed = Math.min(300, Math.min(1500, Math.abs(initialY - targetY)))
    start = undefined
    t = undefined
    y = undefined
    frame = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or (callback) ->
      setTimeout callback, 15

    return if scrollToTopInProgress
    return if delta == 0

    abort = ->
      scrollToTopInProgress = false
    scrollToTopInProgress = true

    smooth = (pos) ->
      return 0.5 * Math.pow(pos, 5) if (pos /= 0.5) < 1
      0.5 * (Math.pow((pos - 2), 5) + 2)

    frame render = (now) ->
      return unless scrollToTopInProgress
      start = now  unless start
      t = Math.min(1, Math.max((now - start) / speed, 0))
      y = Math.round(initialY + delta * smooth(t))
      y = targetY  if delta > 0 and y > targetY
      y = targetY  if delta < 0 and y < targetY
      window.scrollTo(0, y) unless lastY is y
      lastY = y
      if y isnt targetY
        frame render
      else
        abort()