angular.module('app.directives')
.directive("clickOutside", ['$timeout', ($timeout)->
    restrict: "ECA"
    priority: 1000

    link: (scope, elm, attrs) ->
      $timeout(->
        # Handlerof clicking on document
        handler = (evt) ->
          target = angular.element(evt.target)
          if not target.closest(elm) and (not attrs.exclude or target.closest(attrs.exclude) == document)
            scope.$apply(attrs.clickOutside)

        # Check any click and try to find closest
        angular.element(document).on('click', handler)
        scope.$on('$destroy', ->
          angular.element(document).off('click', handler)
        )
      )
  ])
