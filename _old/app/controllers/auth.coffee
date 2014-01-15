'use strict'

angular.module('app.controllers')
.controller('AuthCtrl', [
    '$scope'
    '$rootScope'
    '$window'
    'User'

    ($scope, $rootScope, $window, User) ->
      $scope.authenticate = ->
        User.auth()
  ])