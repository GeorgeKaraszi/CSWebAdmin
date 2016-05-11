ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserShowCtrl', ['$scope', ($scope)->
  $scope.showData = 'Hello World: ShowCtrl'
]