angular.element.fn = angular.element.prototype
angular.extend(angular.element.fn,
  closest: (selector) ->
    if angular.isString(selector)
      elem = this[0]
      matchesSelector = elem.matches or elem.webkitMatchesSelector or elem.mozMatchesSelector or elem.msMatchesSelector

      while (elem)
        if elem == document
          return document
        if matchesSelector.call(elem, selector)
          return elem
        else
          elem = elem.parentNode

      return false
    else if angular.isElement(selector)
      selector = selector[0]
      elem = this[0]

      while (elem)
        if elem == document
          return false
        if elem == selector
          return elem
        else
          elem = elem.parentNode

      return false

  focus: ->
    return this[0].focus()
);