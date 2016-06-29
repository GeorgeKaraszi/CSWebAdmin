ldapManager = angular.module('ldapManager')

ldapManager.controller 'GroupIndexCtrl', ['$scope', 'Notice', 'Crud', ($scope, Notice, Crud)->
  $scope.init = ()->
    $scope.notice = Notice.GetMessage()
    $scope.entryCN= 'Group Name'
    $scope.entryIdName = 'GID'
    $scope.entryList = Crud.all()
]

ldapManager.controller 'GroupNewCtrl', ['$scope', 'Notice','Crud', ($scope, Notice, Crud)->
  $scope.ldapForm = {}

  $scope.init = () ->
    $scope.service = Notice.init()
    $scope.requestUrl = '/api/v1/group/new'
    $scope.requestObjUrl = '/api/v1/request/schema'

  $scope.submit = ()->
    Crud.create($scope.ldapForm)

  $scope.$watch('service.GetMessage()', (newMessage)->
    $scope.notice = newMessage
  )

]