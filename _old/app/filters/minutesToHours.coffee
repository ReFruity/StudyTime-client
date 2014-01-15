angular.module('app.filters')
.filter('minutesToHours', [->
    (input) ->
        value = parseInt(input)
        hours = Math.floor(value / 60)
        minutes = value - hours * 60
        return (if hours < 10 then "0"+hours else hours) + ":" + (if minutes < 10 then "0"+minutes else minutes)
])