ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserIndexCtrl', ['$scope', 'Notice', 'Crud', ($scope, Notice, Crud)->
  $scope.init = ()->
    @crudService = new Crud()
    $scope.notice = Notice.GetMessage()
    $scope.entryCN= 'UserName'
    $scope.entryIdName = 'UID'
    $scope.entryList = @crudService.all()
    
    $scope.testAll = ()->
      $scope.entryList = @crudService.all()

]

ldapManager.controller 'UserNewCtrl', ['$scope', 'Notice','Crud', ($scope, Notice, Crud)->
  $scope.ldapForm = {}

  $scope.init = () ->
    Notice.init()
    $scope.service = Notice
    @crudService = new Crud()
    $scope.requestUrl = '/api/request/user/'

  $scope.submit = ()->
    @crudService.create($scope.ldapForm)

    $scope.$watch('service.GetMessage()', (newMessage)->
      $scope.notice = newMessage
    )
  
]

ldapManager.controller 'UserEditCtrl', ['$scope', '$stateParams', 'Notice', 'Crud',
  ($scope, $stateParams, Notice, Crud)->
    $scope.ldapForm = {}

    $scope.init = () ->
      Notice.init()
      $scope.service = Notice
      @crudService = new Crud($stateParams.id)
      $scope.requestUrl = '/api/request/user/' + $stateParams.id
      $scope.entryData = @crudService.get()

    $scope.submit = ()->
      @crudService.update($stateParams.id, $scope.ldapForm)

    $scope.$watch('service.GetMessage()', (newMessage)->
      $scope.notice = newMessage
    )

]

ldapManager.controller 'UserShowCtrl', ['$scope', '$stateParams', 'Notice', 'Crud',
  ($scope, $stateParams, Notice, Crud)->
    $scope.init = ()->
      @crudService = new Crud($stateParams.id)
      $scope.entryData = @crudService.get()
      $scope.notice = Notice.GetMessage()

    $scope.ensureArray = (value)->
      return value if angular.isArray(value)
      return [value]
  
]

ldapManager.controller 'UserDestroyCtrl', ['$scope', '$stateParams','Crud',
  ($scope, $stateParams, Crud)->
    @crudService = new Crud($stateParams.id)
    @crudService.delete($stateParams.id)
]