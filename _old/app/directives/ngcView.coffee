angular.module('app.directives')
.directive "ngcView", [
    "$http"
    "$templateCache"
    "$route"
    "$anchorScroll"
    "$compile"
    "$controller"
    "$animate"
    "$timeout"

    ($http, $templateCache, $route, $anchorScroll, $compile, $controller, animate, $timeout) ->
      restrict: "ECA"
      terminal: true
      link: (scope, element, attr) ->
        lastScope = undefined
        currentOriginalPath = undefined
        currentParams = undefined
        firstCall = true
        onloadExp = attr.onload or ""

        destroyLastScope = ->
          if lastScope
            lastScope.$destroy()
            lastScope = null

        enterAnimationDone = ->
          lastScope.$emit "$viewContentChangeEnd"

        clearContent = ->
          if element.contents().length > 0
            animate.leave element.contents()
          destroyLastScope()

        update = ->
          locals = $route.current and $route.current.locals
          template = locals and locals.$template

          if $route.current and $route.current.$$route
            if $route.current.$$route.preventNestedReload and currentOriginalPath is $route.current.$$route.originalPath
              if $route.current.$$route.dependencies
                for d of $route.current.$$route.dependencies
                  paramName = $route.current.$$route.dependencies[d]
                  return if currentParams[paramName] is $route.current.params[paramName]
              else
                return
            currentOriginalPath = $route.current.$$route.originalPath
            currentParams = angular.copy($route.current.params)

          if template
            clearContent()
            enterElements = angular.element("<div></div>").html(template).contents()
            current = $route.current
            controller = undefined
            lastScope = current.scope = scope.$new()
            lastScope.$emit "$viewContentChangeStart"

            # Skip first animation
            if firstCall
              element.append(enterElements)
              enterAnimationDone && $timeout(enterAnimationDone, 0, false);
              firstCall = false
            else
              animate.enter enterElements, element, null, enterAnimationDone

            link = $compile(enterElements)
            if current.controller
              locals.$scope = lastScope
              controller = $controller(current.controller, locals)
              lastScope[current.controllerAs] = controller  if current.controllerAs
              element.children().data "$ngControllerController", controller
            link lastScope
            lastScope.$emit "$viewContentLoaded"
            lastScope.$eval onloadExp
          else
            clearContent()

        # Initial update
        scope.$on "$routeChangeSuccess", update
        update()
  ]