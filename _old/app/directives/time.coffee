angular.module('app.directives')
.directive "time",[
    '$filter'

    ($filter) ->
      TIME_REGEXP = /^(((0|1)?[0-9])|2[0-3]):([0-5][0-9])$/

      require: "ngModel"
      link: (scope, elm, attrs, ctrl) ->
        ctrl.$parsers.unshift (viewValue) ->
          if TIME_REGEXP.test(viewValue)
            ctrl.$setValidity "time", true
            parts = viewValue.split(":")
            val = parts[0] * 60 + parseInt(parts[1])
            (if val > 1440 then 1440 else ((if val < 0 then 0 else val)))
          else
            ctrl.$setValidity "time", false
            `undefined`

        ctrl.$formatters.push (modelValue) ->
          $filter('minutesToHours')(modelValue) if modelValue
  ]