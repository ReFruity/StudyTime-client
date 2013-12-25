angular.module('app.directives')
.directive('moveContentTo', ['$timeout', '$compile', ($timeout, $compile)->
    restrict: 'A',
    compile: (element, attrs) ->
      content = element[0].innerHTML
      element[0].innerHTML = ""

      return ($scope, element, attrs) ->
        element = $compile("<span>"+content+"</span>")($scope)
        $timeout(->
          elem = angular.element(document.querySelector("#"+attrs.moveContentTo))
          elem.html("")
          elem.append(element)
        )

  ])