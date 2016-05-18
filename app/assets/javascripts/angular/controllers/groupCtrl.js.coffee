ldapManager = angular.module('ldapManager')

ldapManager.controller 'GroupIndexCtrl', ['$scope', 'Crud', ($scope, Crud)->
  $scope.init = ()->
    console.log('Init IndexController')
    @crudService = new Crud()
    $scope.entryCN= 'Group Name'
    $scope.entryIdName = 'GID'
    $scope.entryList = @crudService.all()

  $scope.ensureEntryId = (entry)->
    return entry.attributes.gidNumber

]

ldapManager.controller 'GroupNewCtrl', ['$scope', 'Notice','Crud', ($scope, Notice, Crud)->
  $scope.ldapForm = {}

  $scope.init = () ->
    console.log('Init NewController')
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
      console.log('Init EditController')
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
      console.log('Init ShowController')
      @crudService = new Crud($stateParams.id)
      $scope.entryData = @crudService.get()
      $scope.notice = Notice.GetMessage()

    $scope.ensureArray = (value)->
      return value if angular.isArray(value)
      return [value]

]

ldapManager.controller 'GroupDestroyCtrl', ['$scope', '$state', '$stateParams','Crud',
  ($scope, $state, $stateParams, Crud)->
    @crudService = new Crud($stateParams.id)
    @crudService.delete($stateParams.id)
    console.log('DestroyCtrl')
    $state.go('^',{},{reload: true})
]