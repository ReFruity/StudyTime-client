angular.module('app.filters')
.filter('startFrom', [->
    (input, start) ->
        return input.slice(start)
])