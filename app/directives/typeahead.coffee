angular.module('app.directives')
.directive "typeahead", ["$timeout", ($timeout) ->
  restrict: "E"
  transclude: true
  replace: true
  template: "<div><form><input ng-model=\"term\" ng-change=\"query()\" type=\"text\" autocomplete=\"off\" /></form><div ng-transclude></div></div>"
  scope:
    search: "&"
    select: "&"
    items: "="
    term: "="

  controller: ["$scope", ($scope) ->
    $scope.items = []
    $scope.hide = false
    @activate = (item) ->
      $scope.active = item

    @activateNextItem = ->
      index = $scope.items.indexOf($scope.active)
      @activate $scope.items[(index + 1) % $scope.items.length]

    @activatePreviousItem = ->
      index = $scope.items.indexOf($scope.active)
      @activate $scope.items[(if index is 0 then $scope.items.length - 1 else index - 1)]

    @isActive = (item) ->
      $scope.active is item

    @selectActive = ->
      @select $scope.active

    @select = (item) ->
      $scope.hide = true
      $scope.focused = true
      $scope.select item: item

    $scope.isVisible = ->
      not $scope.hide and ($scope.focused or $scope.mousedOver)

    $scope.query = ->
      $scope.hide = false
      $scope.search term: $scope.term
  ]
  link: (scope, element, attrs, controller) ->
    $input = element.find("form > input")
    $list = element.find("> div")
    $input.bind "focus", ->
      scope.$apply ->
        scope.focused = true


    $input.bind "blur", ->
      scope.$apply ->
        scope.focused = false


    $list.bind "mouseover", ->
      scope.$apply ->
        scope.mousedOver = true


    $list.bind "mouseleave", ->
      scope.$apply ->
        scope.mousedOver = false


    $input.bind "keyup", (e) ->
      if e.keyCode is 9 or e.keyCode is 13
        scope.$apply ->
          controller.selectActive()

      if e.keyCode is 27
        scope.$apply ->
          scope.hide = true


    $input.bind "keydown", (e) ->
      e.preventDefault()  if e.keyCode is 9 or e.keyCode is 13 or e.keyCode is 27
      if e.keyCode is 40
        e.preventDefault()
        scope.$apply ->
          controller.activateNextItem()

      if e.keyCode is 38
        e.preventDefault()
        scope.$apply ->
          controller.activatePreviousItem()


    scope.$watch "items", (items) ->
      controller.activate (if items.length then items[0] else null)

    scope.$watch "focused", (focused) ->
      if focused
        $timeout (->
          $input.focus()
        ), 0, false

    scope.$watch "isVisible()", (visible) ->
      if visible
        pos = $input.position()
        height = $input[0].offsetHeight
        $list.css
          top: pos.top + height
          left: pos.left
          position: "absolute"
          display: "block"

      else
        $list.css "display", "none"

]

angular.module('app.directives')
.directive "typeaheadItem", ->
  require: "^typeahead"
  link: (scope, element, attrs, controller) ->
    item = scope.$eval(attrs.typeaheadItem)
    scope.$watch (->
      controller.isActive item
    ), (active) ->
      if active
        element.addClass "active"
      else
        element.removeClass "active"

    element.bind "mouseenter", (e) ->
      scope.$apply ->
        controller.activate item


    element.bind "click", (e) ->
      scope.$apply ->
        controller.select item