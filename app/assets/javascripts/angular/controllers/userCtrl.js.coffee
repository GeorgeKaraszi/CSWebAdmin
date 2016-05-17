ldapManager = angular.module('ldapManager')

ldapManager.controller 'UserIndexCtrl', ['$scope', 'Notice', 'User', ($scope, Notice, User)->
  console.log('init')
  $scope.init = ()->
    $scope.notice = Notice.Message()
    @userService = new User()
    $scope.entryCN= 'UserName'
    $scope.entryIdName = 'UID'
    $scope.entryList = @userService.all()

  $scope.ensureEntryId = (entry)->
    return entry.attributes.uidNumber

]

ldapManager.controller 'UserNewCtrl', ['$scope', 'User', ($scope, User)->
  $scope.ldapForm = {}
  console.log('this')
  $scope.init = () ->
    @userService = new User()
    $scope.requestUrl = '/api/request/user/'

  $scope.submit = ()->
    @userService.create($scope.ldapForm)
  
]

ldapManager.controller 'UserEditCtrl', ['$scope','$state', '$stateParams', 'Notice', 'User',
  ($scope, $state, $stateParams, Notice, User)->
    $scope.ldapForm = {}

    $scope.init = () ->
      Notice.init()
      @userService = new User($stateParams.id)
      $scope.requestUrl = '/api/request/user/' + $stateParams.id
      $scope.entryData = @userService.get()

    $scope.submit = ()->
      @userService.update($stateParams.id, $scope.ldapForm).then(
        (goodStatus)->
          Notice.SetMessage(goodStatus.notice, 1)
          $state.go('ldap_users.show', {id: $stateParams.id}, {reload: true})

        ,(badStatus)->
          $scope.notice = badStatus.notice
          console.log('Error')
      )
]

ldapManager.controller 'UserShowCtrl', ['$scope','$state', '$stateParams', 'User',
  ($scope,$state, $stateParams, User)->
    $scope.init = ()->
      @userService = new User($stateParams.id)
      $scope.entryData = @userService.get()
      $scope.currentState = $state.current.name

    $scope.ensureArray = (value)->
      return value if angular.isArray(value)
      return [value]
  
]

ldapManager.controller 'UserDestroyCtrl', ['$scope', '$state', '$stateParams','User',
  ($scope, $state, $stateParams, User)->
      @userService = new User($stateParams.id)
      @userService.delete($stateParams.id)

      $state.go('ldap_users',{},{reload: true})
]