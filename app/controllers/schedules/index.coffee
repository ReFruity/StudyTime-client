ScheduleIndexCtrl = ($scope) ->
  $scope.groups =
    "КН": [
      [{name: 101}, {name: 102}, {name: 103}],
      [{name: 201}, {name: 202}, {name: 203}],
      [{name: 301}, {name: 302}],
    ]
    "КБ": [
      [{name: 101}, {name: 102}, {name: 103}],
      [{name: 201}, {name: 202}, {name: 203}],
      [{name: 301}, {name: 302}],
    ]
    "МТ": [
      [{name: 101}, {name: 102}, {name: 103}],
      [{name: 201}, {name: 202}, {name: 203}],
      [{name: 301}, {name: 302}],
    ]
    "МХ": [
      [{name: 101}, {name: 102}, {name: 103}],
      [{name: 201}, {name: 202}, {name: 203}],
      [{name: 301}, {name: 302}],
    ]
    "ПИ": [
      [{name: 101}, {name: 102}, {name: 103}],
      [{name: 201}, {name: 202}, {name: 203}],
      [{name: 301}, {name: 302}],
    ]
    "ФТ": [
      [{name: 101}, {name: 102}, {name: 103}],
      [{name: 201}, {name: 202}, {name: 203}],
      [{name: 301}, {name: 302}],
    ]


ScheduleIndexCtrl.$inject = ["$scope"]