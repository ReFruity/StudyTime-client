angular.module('app.directives')
.directive "identifiersList",[
    '$filter'

    ($filter) ->

      require: "ngModel"
      link: (scope, elm, attrs, ctrl) ->
        ctrl.$parsers.unshift (viewValue) ->
          viewValue

        ctrl.$formatters.push (modelValue) ->
          if angular.isArray(modelValue)
            return (v.name for v in modelValue).join(", ")
          else if angular.isObject(modelValue) and modelValue.name
            return modelValue.name
          else
            return ""
  ]