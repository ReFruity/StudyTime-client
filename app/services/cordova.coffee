angular.module('app.services')

.factory('cordovaLocalStorage', [
    'cordovaReady'
    (cordovaReady) ->
      cordovaReady.then ->
        window.localStorage
  ])

.factory('cordovaReady', [
    'checkPhonegap'
    '$q'
    (checkPhonegap, $q) ->
      deferred = $q.defer();

      if !checkPhonegap()
        deferred.resolve(true)
      else
        document.addEventListener "deviceready", (->
          deferred.resolve(true)
        ), false

      deferred.promise
  ])