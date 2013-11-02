angular.module('app.services')
.factory "Group", ($resource) ->
    $resource "/api/v1/group/:groupName/:_method",
      groupName: "@name"
    ,
      query:
        method: "GET"
        isArray: false

      cut:
        method: "GET"
        params:
          _method: "cut"
