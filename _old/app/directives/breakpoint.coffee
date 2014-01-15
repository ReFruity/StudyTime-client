angular.module('app.directives')
.directive "breakpoint", ->
  (scope, element, attrs) ->
    if window.matchMedia
      breakpoint = attrs.breakpoint
      mql = window.matchMedia("(" + breakpoint + ")")
      mqlListener = (mql) ->
        scope.matches = mql.matches
        scope.$apply() unless scope.$$phase

      mql.addListener mqlListener
      mqlListener mql
    else
      scope.matches = false