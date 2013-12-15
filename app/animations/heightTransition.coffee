angular.module('app.animations')
.animation ".height-transition", [
    '$timeout'
    '$rootScope'

    ($timeout, $rootScope) ->
      enter: (element, done) ->
        element[0].style.position = "absolute"
        element[0].style.opacity = "0"
        element[0].style.display = "block"
        contentHeight = element[0].offsetHeight
        element[0].style.maxHeight = "0px"
        element[0].style.overflow = "hidden"
        element.removeClass('max-height-transition')

        $timeout(->
          element[0].style.position = "relative"
          element[0].style.opacity = "1"
          element.addClass('max-height-transition')
          element[0].style.maxHeight = contentHeight + "px"

          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
            element[0].style.maxHeight = "9999px"
            element[0].style.overflow = "visible"
            done()
          )
        , 10)

        return undefined

      leave: (element, done) ->
        element[0].style.display = "block"
        contentHeight = element[0].offsetHeight + 1
        element.removeClass('max-height-transition')
        element[0].style.maxHeight = contentHeight + "px"
        element[0].style.overflow = "hidden"

        $timeout(->
          element.addClass('max-height-transition')
          element[0].style.maxHeight = "0px"
          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
            element[0].style.overflow = "visible"
            done()
          )
        , 10)

        return undefined
  ]
