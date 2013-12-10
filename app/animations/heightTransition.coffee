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
          doneInvoked = false
          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
            doneInvoked = true
            element[0].style.maxHeight = "9999px"
            done()
          )
          $timeout(->
            if not doneInvoked
              done()
          , 900)
        , 10)

        return undefined

      leave: (element, done) ->
        contentHeight = element[0].offsetHeight + 1
        element.removeClass('max-height-transition')
        element[0].style.maxHeight = contentHeight + "px"

        $timeout(->
          element.addClass('max-height-transition')
          element[0].style.maxHeight = "0px"
          doneInvoked = false
          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
            doneInvoked = true
            done()
          )
          $timeout(->
            if not doneInvoked
              done()
          , 900)
        , 10)

        return undefined
  ]
