ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserIndexCtrl', ['$scope', ($scope)->
  console.log('In da index ctrl')
  $scope.showData = 'Hello World: IndexCtrl'
]