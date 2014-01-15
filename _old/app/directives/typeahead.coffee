angular.module('app.directives')
.directive "typeahead", ["$timeout", ($timeout) ->
  restrict: "E"
  replace: yes
  template: (elem) ->
    "<div style='position: relative; z-index: 1000000;display: none;'>"+elem[0].innerHTML+"</div>"
  scope:
    finder: "@"
    term: "="

  controller: ['$scope', 'User', 'Subject', 'Group', 'Place', '$q', ($scope, User, Subject, Group, Place, $q) ->
      # Typeahead services
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
        if $scope.active
          @select $scope.active

      @select = (item) ->
        $scope.hide = true
        $scope.focused = true
        $scope.term = item

      $scope.isVisible = ->
        not $scope.hide and ($scope.focused or $scope.mousedOver) and $scope.items.length > 0

      # Make a query
      activeRequest = undefined
      $scope.$watch "term", (term)->
        if term and term.length > 0 and angular.isString(term)
          # Cancel previous request
          if activeRequest
            activeRequest.resolve()
            activeRequest = undefined

          # Start new request
          activeRequest = $q.defer()
          $scope.hide = false
          finders[$scope.finder](term)
        else
          $scope.items = []

      # Model finders
      finders =
        group: (term)->
          Group.search(term, 'ИМКН', 0, 15, activeRequest.promise).success((data)->
            $scope.items = data.groups
          )

        subject: (term)->
          Subject.search(term, 0, 15, activeRequest.promise).success((data)->
            $scope.items = data.subjects
          )

        user: (term)->
          User.search(term, 0, 15, activeRequest.promise).success((data)->
            $scope.items = data.users
          )

        place: (term)->
          Place.search(term, activeRequest.promise).success((data)->
            $scope.items = data.places
          )

      # Return controller
      return this
    ]


  link: (scope, element, attrs, controller) ->
    $timeout(->
      $input = angular.element(document.getElementById(attrs.for))
      $list = angular.element(element.children()[0])

      $input.on "focus", ->
        scope.$apply ->
          scope.focused = true

      $input.on "blur", ->
        scope.$apply ->
          scope.focused = false


      $list.on "mouseover", ->
        scope.$apply ->
          scope.mousedOver = true


      $list.on "mouseleave", ->
        scope.$apply ->
          scope.mousedOver = false


      $input.on "keyup", (e) ->
        if e.keyCode is 9 or e.keyCode is 13
          scope.$apply ->
            controller.selectActive()

        if e.keyCode is 27
          scope.$apply ->
            scope.hide = true


      $input.on "keydown", (e) ->
        e.preventDefault() if (e.keyCode is 9 or e.keyCode is 13 or e.keyCode is 27) and scope.items and scope.items.length > 0
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
          element.css "display", "block"
          $list.css
            position: "absolute"
            display: "block"
            zIndex: 100000
            width: $input[0].offsetWidth+"px"

        else
          element.css "display", "none"
          $list.css "display", "none"
    )
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

    element.on "mouseenter", (e) ->
      scope.$apply ->
        controller.activate item


    element.on "click", (e) ->
      scope.$apply ->
        controller.select item