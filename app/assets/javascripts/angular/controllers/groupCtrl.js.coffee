ldapManager = angular.module('ldapManager')

ldapManager.controller 'GroupIndexCtrl', ['$scope', 'Notice', 'Crud', ($scope, Notice, Crud)->
  $scope.init = ()->
    @crudService = new Crud()
    $scope.notice = Notice.GetMessage()
    $scope.entryCN= 'Group Name'
    $scope.entryIdName = 'GID'
    $scope.entryList = @crudService.all()

  $scope.ensureEntryId = (entry)->
    return entry.attributes.gidNumber

]

ldapManager.controller 'GroupNewCtrl', ['$scope', 'Notice','Crud', ($scope, Notice, Crud)->
  $scope.ldapForm = {}

  $scope.init = () ->
    Notice.init()
    @crudService = new Crud()
    $scope.requestUrl = '/api/request/group/'

  $scope.submit = ()->
    @crudService.create($scope.ldapForm)

]

ldapManager.controller 'GroupEditCtrl', ['$scope', '$stateParams', 'Notice', 'Crud',
  ($scope, $stateParams, Notice, Crud)->
    $scope.ldapForm = {}

    $scope.init = () ->
      Notice.init()
      @crudService = new Crud($stateParams.id)
      $scope.requestUrl = '/api/request/group/' + $stateParams.id
      $scope.entryData = @crudService.get()

    $scope.submit = ()->
      @crudService.update($stateParams.id, $scope.ldapForm)

]

ldapManager.controller 'GroupShowCtrl', ['$scope', '$stateParams', 'Notice', 'Crud',
  ($scope, $stateParams, Notice, Crud)->
    $scope.init = ()->
      @crudService = new Crud($stateParams.id)
      $scope.entryData = @crudService.get()
      $scope.notice = Notice.GetMessage()

    $scope.ensureArray = (value)->
      return value if angular.isArray(value)
      return [value]

]

ldapManager.controller 'GroupDestroyCtrl', ['$scope', '$stateParams','Crud',
  ($scope, $stateParams, Crud)->
    @crudService = new Crud($stateParams.id)
    @crudService.delete($stateParams.id)
]