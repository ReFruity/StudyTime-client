angular.module('app.directives')
.run([
    '$rootScope'

    ($rootScope) ->
      # Create global list of nonbounce elements
      $rootScope.__non_bounce = []
      startY = 0

      # Track touch start
      angular.element(document).on('touchstart', (evt) ->
        startY = if evt.touches then evt.touches[0].screenY else evt.screenY
      )

      # Track touch move
      angular.element(document).on('touchmove', (evt) ->
        # Prevents scrolling of all but the nonbounce elements
        if not (evt.touches and evt.touches.length > 1)
          if (e == evt.target for e in $rootScope.__non_bounce).indexOf(true) >= 0
            evt.preventDefault()

        # Prevents scrolling of nonbounce element if bound conditions are met
        if (!hasCorrectBounds(evt))
          evt.preventDefault()
      )

      hasCorrectBounds = (evt) ->
        y = if evt.touches then evt.touches[0].screenY else evt.screenY
        nonbounce = closest(evt.target, ".non-bounce")

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

      closest = (elem, selector) ->
        matchesSelector = elem.matches or elem.webkitMatchesSelector or elem.mozMatchesSelector or elem.msMatchesSelector;

        while (elem)
          if elem == document
            return document
          if matchesSelector.call(elem, selector)
            return elem
          else
            elem = elem.parentNode

        return false
  ])
.directive("nonBounce", [ "$animate", ($animate) ->
    restrict: "ECA"
    priority: 1000

    link: (scope, elm, attrs) ->
      scope.__non_bounce.push(elm[0])
  ])