ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserNewCtrl', ['$scope', ($scope)->
  $scope.showData = 'Hello World: NewCtrl'
]