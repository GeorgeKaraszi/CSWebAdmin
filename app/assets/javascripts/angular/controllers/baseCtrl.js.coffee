ldapManager = angular.module('ldapManager')


ldapManager.controller 'EntryShowCtrl', ['$scope', '$stateParams', 'Notice', 'Crud',
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

ldapManager.controller 'EntryEditCtrl', ['$scope', '$stateParams', 'Notice', 'Crud',
  ($scope, $stateParams, Notice, Crud)->
    $scope.ldapForm = {}

    $scope.init = () ->
      $scope.service = Notice.init()
      $scope.requestUrl = '/api/v1/request/' + $stateParams.id
      $scope.requestObjUrl = $scope.requestUrl + '/schema'
      $scope.entryData = Crud.get($stateParams.id)

    $scope.submit = ()->
      Crud.update($stateParams.id, $scope.ldapForm)

    $scope.$watch('service.GetMessage()', (newMessage)->
      $scope.notice = newMessage
    )

]


ldapManager.controller 'EntryDestroyCtrl', ['$scope', '$stateParams','Crud',
  ($scope, $stateParams, Crud)->
    Crud.delete($stateParams.id)
]