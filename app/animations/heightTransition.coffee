angular.module('app.animations')
.animation ".height-transition", [
    '$timeout'
    '$rootScope'

    ($timeout, $rootScope) ->
      enter: (element, done) ->
        contentHeight = element[0].offsetHeight
        element.removeClass('max-height-transition')
        element[0].style.maxHeight = "0px"

        $timeout(->
          element.addClass('max-height-transition')
          element[0].style.maxHeight = contentHeight + "px"
          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
            element[0].style.maxHeight = "9999px"
            done()
          )
        , 10)

        return undefined

      leave: (element, done) ->
        contentHeight = element[0].offsetHeight + 1
        element.removeClass('max-height-transition')
        element[0].style.maxHeight = contentHeight + "px"

        $timeout(->
          element.addClass('max-height-transition')
          element[0].style.maxHeight = "0px"
          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
            done()
          )
        , 10)

        return undefined
  ]
