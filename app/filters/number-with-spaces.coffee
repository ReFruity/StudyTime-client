angular.module('app.filters')
.filter('numberWithSpaces', [->
    isNumber = (n) ->
      !isNaN(parseFloat(n)) && isFinite(n)

    (x) ->
      return x if not isNumber(x)
      parts = x.toString().split(".");
      parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, " ");
      parts[1] = parts[1].substr(0, 2) if parts.length > 1
      parts.join(".");
])