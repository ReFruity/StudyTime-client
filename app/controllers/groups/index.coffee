angular.module('app.controllers')

.controller('GroupsIndexCtrl', [
    '$scope'
    'config'
    'Group'

    ($scope, config, Group) ->
      #TODO: redirect to last opened group

#      Group.

#      Group.get(faculty: config.facultyId).success (data) ->
#        console.log(data)

#      console.log()
      $scope.chunks = [];
      $scope.groups = Group.get faculty: config.facultyId, (groups) ->
        $scope.groupKeys = _.keys($scope.groups)

        #deleting angular keys
        for key in ['$promise', '$resolved']
          $scope.groupKeys.splice($scope.groupKeys.indexOf(key), 1)

#        console.log($scope.groupKeys)

#        length = _.keys(groups).length - 2 # убираем $promise и $resolved
#        for i in [0..length] by 4
#          $scope.chunks.push( $scope.numbers.slice(i, i + 2) )



#      console.log("!groups!")
#      console.log($scope.groups)
#      console.log($scope.groups.groups)

#      $scope.groups =
#        "КН": [
#          [
#            {name: 101},
#            {name: 102},
#            {name: 103},
#            {name: 104}
#          ],
#          [
#            {name: 201},
#            {name: 202},
#            {name: 203}
#          ],
#          [
#            {name: 301},
#            {name: 302}
#          ],
#        ]
#        "КБ": [
#          [
#            {name: 101},
#            {name: 102},
#            {name: 103}
#            {name: 104}
#          ],
#          [
#            {name: 201},
#            {name: 202},
#            {name: 203}
#            {name: 204}
#          ],
#          [
#            {name: 301},
#            {name: 302}
#          ],
#        ]
#        "МТ": [
#          [
#            {name: 101},
#            {name: 102},
#            {name: 103}
#          ],
#          [
#            {name: 201},
#            {name: 202},
#            {name: 203}
#          ],
#          [
#            {name: 301},
#            {name: 302}
#          ],
#        ]
#        "МХ": [
#          [
#            {name: 101},
#            {name: 102},
#            {name: 103}
#          ],
#          [
#            {name: 201},
#            {name: 202},
#            {name: 203}
#          ],
#          [
#            {name: 301},
#            {name: 302}
#          ],
#        ]
#        "ПИ": [
#          [
#            {name: 101},
#            {name: 102},
#            {name: 103}
#          ],
#          [
#            {name: 201},
#            {name: 202},
#            {name: 203}
#          ],
#          [
#            {name: 301},
#            {name: 302}
#          ],
#        ]
#        "ФТ": [
#          [
#            {name: 101},
#          ],
#          [
#            {name: 201},
#          ],
#          [
#            {name: 301},
#          ],
#          [
#            {name: 401},
#          ],
#          [
#            {name: 501},
#          ],
#        ]
#      console.log(_.keys($scope.groups))
#      $scope.groupKeys = _.keys($scope.groups)
  ])
