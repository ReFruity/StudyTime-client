angular.module('app.services').factory "Group", ($resource, config) ->
  $resource config.apiUrl + '/group/:_method', {},
    query:
      method: "GET"
      isArray: false