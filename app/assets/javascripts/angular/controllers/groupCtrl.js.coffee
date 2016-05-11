ldapManager = angular.module('ldapManager')

ldapManager.controller 'GroupIndexCtrl', ['$scope', 'Group', ($scope, Group)->
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
  $scope.requestUrl = '/api/ldap_groups/' + $stateParams.id + '/ldap/request.json'
  $scope.ldapForm = {}

  $scope.init = () ->
    @groupServices = new Group($stateParams.id)
    $scope.entryData = @groupServices.getGroup()


  $scope.submit = ()->
    console.log('submitting')
    console.log(@groupServices)
    @groupServices.update($stateParams.id, $scope.ldapForm)
    console.log('submitted')
]

ldapManager.controller 'GroupShowCtrl', ['$scope', '$stateParams','Group', ($scope, $stateParams, Group)->
  @groupServices = new Group($stateParams.id)
  $scope.entryData = @groupServices.getGroup()

  $scope.ensureArray = (value)->
    return value if angular.isArray(value)
    return [value]

]

ldapManager.controller 'GroupDestroyCtrl', ['$scope', '$stateParams','Group', ($scope, $stateParams, Group)->
  $scope.showData = 'Hello World: ShowCtrl'
]