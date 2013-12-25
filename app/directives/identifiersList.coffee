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
            return modelValue[0].name
          else if angular.isObject(modelValue) and modelValue.name
            return modelValue.name
          else
            return modelValue
  ]