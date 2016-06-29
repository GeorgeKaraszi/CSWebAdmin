ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserIndexCtrl', ['$scope', 'Notice', 'Crud', ($scope, Notice, Crud)->
  $scope.init = ()->
    $scope.notice = Notice.GetMessage()
    $scope.entryCN= 'UserName'
    $scope.entryIdName = 'UID'
    $scope.entryList = Crud.all()
]

ldapManager.controller 'UserNewCtrl', ['$scope', 'Notice','Crud', ($scope, Notice, Crud)->
  $scope.ldapForm = {}

  $scope.init = () ->
    $scope.service = Notice.init()
    $scope.requestUrl = '/api/v1/user/new'
    $scope.requestObjUrl = '/api/v1/request/schema'

  $scope.submit = ()->
    Crud.create($scope.ldapForm)

  $scope.$watch('service.GetMessage()', (newMessage)->
    $scope.notice = newMessage
  )
  
]