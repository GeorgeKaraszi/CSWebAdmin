ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserIndexCtrl', ['$scope', 'User', ($scope, User)->
  $scope.init = ()->
    @userService = new User()
    $scope.entryCN= 'UserName'
    $scope.entryIdName = 'UID'
    $scope.entryList = @userService.all()

  $scope.ensureEntryId = (entry)->
    return entry.attributes.uidNumber

]

ldapManager.controller 'UserNewCtrl', ['$scope', 'User', ($scope, User)->
  $scope.ldapForm = {}

  $scope.init = () ->
    @userService = new User()
    $scope.requestUrl = '/api/request/user/'

  $scope.submit = ()->
    @userService.create($scope.ldapForm)
  
]

ldapManager.controller 'UserEditCtrl', ['$scope', '$stateParams','User', ($scope, $stateParams, User)->
  $scope.ldapForm = {}

  $scope.init = () ->
    @userService = new User($stateParams.id)
    $scope.requestUrl = '/api/request/user/' + $stateParams.id
    $scope.entryData = @userService.getUser()

  $scope.submit = ()->
    @userService.update($stateParams.id, $scope.ldapForm)
]

ldapManager.controller 'UserShowCtrl', ['$scope', '$state', '$stateParams','User', ($scope, $state, $stateParams, User)->
  $scope.init = ()->
    @userService = new User($stateParams.id)
    $scope.entryData = @userService.getUser()
    $scope.currentState = $state.current.name
    console.log($scope.currentState.includes('ldap_users'))

  $scope.ensureArray = (value)->
    return value if angular.isArray(value)
    return [value]
  
]

ldapManager.controller 'UserDestroyCtrl', ['$scope', '$stateParams','User', ($scope, $stateParams, User)->
  $scope.showData = 'Hello World: ShowCtrl'
]