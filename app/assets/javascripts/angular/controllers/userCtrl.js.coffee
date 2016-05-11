ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserIndexCtrl', ['$scope', 'User', ($scope, User)->
  @UserListService = new User()
  $scope.entryCN= 'UserName'
  $scope.entryIdName = 'UID'
  $scope.entryList = @UserListService.all()

  $scope.ensureEntryId = (entry)->
    return entry.attributes.uidNumber

]

ldapManager.controller 'UserNewCtrl', ['$scope', 'User', ($scope, User)->
  $scope.showData = 'Hello World: NewCtrl'
]

ldapManager.controller 'UserEditCtrl', ['$scope', '$stateParams','User', ($scope, $stateParams, User)->
  $scope.requestUrl = '/api/ldap_users/' + $stateParams.id + '/ldap/request.json'
  $scope.ldapForm = {}

  $scope.init = () ->
    @userService = new User($stateParams.id)
    $scope.entryData = @userService.getUser()

    
  $scope.submit = ()->
    console.log('submitting')
    console.log(@userService)
    @userService.update($stateParams.id, $scope.ldapForm)
    console.log('submitted')
]

ldapManager.controller 'UserShowCtrl', ['$scope', '$stateParams','User', ($scope, $stateParams, User)->
  @UserService = new User($stateParams.id)
  $scope.entryData = @UserService.getUser()

  $scope.ensureArray = (value)->
    return value if angular.isArray(value)
    return [value]
  
]

ldapManager.controller 'UserDestroyCtrl', ['$scope', '$stateParams','User', ($scope, $stateParams, User)->
  $scope.showData = 'Hello World: ShowCtrl'
]