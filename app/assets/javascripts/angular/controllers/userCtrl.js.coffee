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
    $scope.requestUrl = '/api/request/user/'
    $scope.requestObjUrl = '/api/request/user/obj/'

  $scope.submit = ()->
    Crud.create($scope.ldapForm)

  $scope.$watch('service.GetMessage()', (newMessage)->
    $scope.notice = newMessage
  )
  
]

ldapManager.controller 'UserEditCtrl', ['$scope', '$stateParams', 'Notice', 'Crud',
  ($scope, $stateParams, Notice, Crud)->
    $scope.ldapForm = {}

    $scope.init = () ->
      $scope.service = Notice.init()
      $scope.requestUrl = '/api/request/user/' + $stateParams.id
      $scope.requestObjUrl = $scope.requestUrl + '/obj'
      $scope.entryData = Crud.get($stateParams.id)

    $scope.submit = ()->
      Crud.update($stateParams.id, $scope.ldapForm)

    $scope.$watch('service.GetMessage()', (newMessage)->
      $scope.notice = newMessage
    )

]

ldapManager.controller 'UserShowCtrl', ['$scope', '$stateParams', 'Notice', 'Crud',
  ($scope, $stateParams, Notice, Crud)->
    $scope.init = ()->
      $scope.service = Notice
      $scope.entryData = Crud.get($stateParams.id)

    $scope.ensureArray = (value)->
      return value if angular.isArray(value)
      return [value]

    $scope.$watch('service.GetMessage()', (newMessage)->
      $scope.notice = newMessage
    )
  
]

ldapManager.controller 'UserDestroyCtrl', ['$scope', '$stateParams','Crud',
  ($scope, $stateParams, Crud)->
    Crud.delete($stateParams.id)
]