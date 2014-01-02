angular.module('app.animations')
.animation ".height-transition", [
    '$timeout'
    '$rootScope'

    ($timeout, $rootScope) ->
      enter: (element, done) ->
        elm = element[0]
        elm.style.position = "absolute"
        elm.style.opacity = "0"
        elm.style.display = "block"

        $timeout(->
          contentHeight = elm.offsetHeight
          elm.style.maxHeight = "0px"
          element.removeClass('max-height-transition')

          $timeout(->
            elm.style.position = "relative"
            elm.style.opacity = "1"
            element.addClass('max-height-transition')
            elm.style.overflow = "hidden"
            elm.style.maxHeight = contentHeight + "px"

            element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
              elm.style.maxHeight = "9999px"
              elm.style.removeProperty('overflow')
              done()
            )
          , 10)
        )

        return undefined

      leave: (element, done) ->
        element[0].style.display = "block"
        contentHeight = element[0].offsetHeight + 1
        element.removeClass('max-height-transition')
        element[0].style.maxHeight = contentHeight + "px"

        $timeout(->
          element.addClass('max-height-transition')
          element[0].style.overflow = "hidden"
          element[0].style.maxHeight = "0px"
          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
            done()
          )
        , 10)

        return undefined
  ]
