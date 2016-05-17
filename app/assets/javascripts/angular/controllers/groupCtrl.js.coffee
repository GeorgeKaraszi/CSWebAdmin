ldapManager = angular.module('ldapManager')

ldapManager.controller 'GroupIndexCtrl', ['$scope', 'Group', ($scope, Group)->
  $scope.init = ()->
    @groupServices = new Group()
    $scope.entryCN= 'Group Name'
    $scope.entryIdName = 'GID'
    $scope.entryList = @groupServices.all()
  
  $scope.ensureEntryId = (entry)->
    return entry.attributes.gidNumber

]

ldapManager.controller 'GroupNewCtrl', ['$scope', 'Group', ($scope, Group)->
  $scope.showData = 'Hello World: NewCtrl'
]

ldapManager.controller 'GroupEditCtrl', ['$scope', '$stateParams','Group', ($scope, $stateParams, Group)->
  $scope.requestUrl = '/api/request/group/' + $stateParams.id
  $scope.ldapForm = {}

  $scope.init = () ->
    @groupServices = new Group($stateParams.id)
    $scope.entryData = @groupServices.get()


  $scope.submit = ()->
    @groupServices.update($stateParams.id, $scope.ldapForm)

]

ldapManager.controller 'GroupShowCtrl', ['$scope', '$state', '$stateParams', 'User', ($scope, $state, $stateParams, Group)->
  $scope.init = ()->
    @groupServices = new User($stateParams.id)
    $scope.entryData = @groupServices.get()
    $scope.currentState = $state.current

  $scope.ensureArray = (value)->
    return value if angular.isArray(value)
    return [value]

]

ldapManager.controller 'GroupDestroyCtrl', ['$scope', '$stateParams','Group', ($scope, $stateParams, Group)->
  @groupServices = new Group($stateParams.id)
  @groupServices.delete($stateParams.id)
]