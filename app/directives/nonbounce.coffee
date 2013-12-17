angular.module('app.directives')
.run([
    '$rootScope'
    '$timeout'

    ($rootScope, $timeout) ->
      # Work only for Apple Standalone application
      html = angular.element(document.documentElement)
      if not html.hasClass('standalone') or html.hasClass('phonegap')
        return

      # Create global list of nonbounce elements
      $rootScope.__non_bounce = []
      startY = 0

      # Lock when changing view
      overlay = undefined
      removeOverlay = ->
        if overlay
          $timeout(->
            overlay.remove()
            overlay = undefined
          , 5, false)

      $rootScope.$on '$viewContentChangeStart', ->
        overlay = angular.element("<div class='overlay'></div>")
        angular.element(document).find('body').append(overlay)
      $rootScope.$on '$viewContentChangeEnd', ->
        $timeout(removeOverlay, 5)


      # Track touch start
      angular.element(document).on('touchstart', (evt) ->
        startY = if evt.touches then evt.touches[0].screenY else evt.screenY
      )

      # Track touch move
      angular.element(document).on('touchmove', (evt) ->
        # Prevents scrolling of all but the nonbounce elements
        if not (evt.touches and evt.touches.length > 1)
          if (e == evt.target for e in $rootScope.__non_bounce).indexOf(true) >= 0
            return evt.preventDefault()

        # Prevents scrolling of nonbounce element if bound conditions are met
        if (!hasCorrectBounds(evt))
          return evt.preventDefault()
      )

      hasCorrectBounds = (evt) ->
        y = if evt.touches then evt.touches[0].screenY else evt.screenY
        nonbounce = angular.element(evt.target).closest(".non-bounce")

        if not nonbounce
          return true

        if nonbounce == document
          return false

        # Prevents scrolling of content to top
        if (nonbounce.scrollTop == 0 && startY <= y)
          return false

        # Prevents scrolling of content to bottom
        if (nonbounce.scrollHeight - nonbounce.offsetHeight == nonbounce.scrollTop && startY >= y)
          return false

        return true

  ])
.directive("nonBounce", [ "$animate", ($animate) ->
    restrict: "ECA"
    priority: 1000

    link: (scope, elm, attrs) ->
      if scope.__non_bounce
        index = scope.__non_bounce.push(elm[0]) - 1

        scope.$on('$destroy', ->
          scope.__non_bounce[index] = undefined
        )
  ])
