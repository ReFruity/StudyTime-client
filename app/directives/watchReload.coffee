angular.module('app.directives')
.directive("watchReload", [ "$animate", ($animate) ->
    transclude: "element"
    priority: 900
    terminal: true
    restrict: "A"
    compile: (element, attr, transclude) ->
      ($scope, $element, $attr) ->
        childElement = undefined
        childScope = undefined
        $scope.$watch $attr.watchReload, ngIfWatchAction = (a, b) ->
          return false  if (a is b and childElement) or not a
          if childElement
            $animate.leave childElement
            childElement = `undefined`
          if childScope
            childScope.$destroy()
            childScope = `undefined`
          childScope = $scope.$new()
          transclude childScope, (clone) ->
            childElement = clone
            $animate.enter clone, $element.parent(), $element
  ])