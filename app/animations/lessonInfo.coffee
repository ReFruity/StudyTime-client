angular.module('app.animations')
.animation ".lesson-info", [
    '$timeout'

    ($timeout) ->
      enter: (element, done) ->
        contentHeight = element[0].offsetHeight
        element.removeClass('lessen-transitions')
        element[0].style.maxHeight = "0px"

        $timeout(->
          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', ->
            element[0].style.maxHeight = "9999px"
            done()
          )
          element.addClass('lessen-transitions')
          element[0].style.maxHeight = contentHeight + "px"
        , 10)

        return undefined

      leave: (element, done) ->
        contentHeight = element[0].offsetHeight
        element.removeClass('lessen-transitions')
        element[0].style.maxHeight = contentHeight + "px"

        $timeout(->
          element.addClass('lessen-transitions')
          element[0].style.maxHeight = "0px"
          element.on('transitionEnd webkitTransitionEnd transitionend oTransitionEnd msTransitionEnd', done)
        , 10)

        return undefined
  ]
