angular.module('app.directives')
.directive "ngcView", [ "$route", "$anchorScroll", "$compile", "$controller", "$animate", "$timeout"
    ($route, $anchorScroll, $compile, $controller, $animate, $timeout) ->
      restrict: "ECA"
      terminal: true
      priority: 1000
      transclude: "element"
      compile: (element, attr, linker) ->
        (scope, $element, attr) ->
          currentScope = undefined
          currentElement = undefined
          currentOriginalPath = undefined
          currentParams = undefined
          onloadExp = attr.onload or ""
          firstCall = true

          cleanupLastView = ->
            if currentScope
              currentScope.$destroy()
              currentScope = null
            if currentElement
              $animate.leave currentElement
              currentElement = null

          enterAnimationDone = ->
            currentScope.$emit "$viewContentChangeEnd"

          update = ->
            locals = $route.current and $route.current.locals
            template = locals and locals.$template

            if $route.current and $route.current.$$route
              if $route.current.$$route.preventNestedReload and currentOriginalPath is $route.current.$$route.originalPath
                if $route.current.$$route.dependencies
                  for d of $route.current.$$route.dependencies
                    paramName = $route.current.$$route.dependencies[d]
                    return  if currentParams[paramName] is $route.current.params[paramName]
                else
                  return
              currentOriginalPath = $route.current.$$route.originalPath
              currentParams = angular.copy($route.current.params)

            if template
              newScope = scope.$new()
              linker newScope, (clone) ->
                cleanupLastView()
                clone.html template
                link = $compile(clone.contents())

                # Replace elements
                current = $route.current
                currentScope = current.scope = newScope
                currentElement = clone

                # Skip first animation
                if firstCall
                  afterNode = $element and $element[$element.length - 1]
                  parentNode = afterNode && afterNode.parentNode
                  afterNextSibling = (afterNode && afterNode.nextSibling) || null;
                  angular.forEach(clone, (node) ->
                    parentNode.insertBefore(node, afterNextSibling)
                  )
                  currentScope.$emit "$viewContentChangeStart"
                  $timeout(enterAnimationDone, 0, false)
                  firstCall = false
                else
                  currentScope.$emit "$viewContentChangeStart"
                  $animate.enter clone, null, $element, enterAnimationDone

                if current.controller
                  locals.$scope = currentScope
                  controller = $controller(current.controller, locals)
                  currentScope[current.controllerAs] = controller  if current.controllerAs
                  clone.data "$ngControllerController", controller
                  clone.contents().data "$ngControllerController", controller

                link currentScope
                currentScope.$emit "$viewContentLoaded"
                currentScope.$eval onloadExp
                $anchorScroll()
            else
              cleanupLastView()

          scope.$on "$routeChangeSuccess", update
          update()
  ]