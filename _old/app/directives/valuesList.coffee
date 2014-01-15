angular.module('app.directives')
.directive "valuesList", [
    '$filter'

    ($filter) ->
      require: "ngModel"
      link: (scope, elm, attrs, ctrl) ->
        ctrl.$parsers.unshift (viewValue) ->
          viewValue

        ctrl.$formatters.push (modelValue) ->
          if angular.isArray(modelValue)
            return modelValue.join(", ")
          else
            return modelValue
  ]