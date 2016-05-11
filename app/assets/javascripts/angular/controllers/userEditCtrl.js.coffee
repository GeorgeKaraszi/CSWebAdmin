ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserEditCtrl', ['$scope', ($scope)->
  $scope.showData = 'Hello World: EditCtrl'
]