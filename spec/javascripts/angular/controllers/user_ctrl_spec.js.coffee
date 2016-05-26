describe('userCtrl', ()->

    beforeEach(module('ldapManager'))

    $scope = undefined
    $httpBackend = undefined
    $state = undefined
    deferred = undefined
    crudCall = undefined

    mockQueryResponse = {dn:"uid=rspecTester,ou=People,dc=cs,dc=wmich,dc=edu",cn:"rspecTester",idNum:99999}
    mockresArry = [mockQueryResponse]

    beforeEach(inject(($controller, _$rootScope_, _$state_, _$httpBackend_)->
        $state = _$state_
        $httpBackend = _$httpBackend_
        $scope = _$rootScope_.$new()

        #Jasmin spy to return promise values
        $controller('UserIndexCtrl', {
            $scope: $scope
        })
        $state.current = {controller:'UserIndexCtrl', name:'ldap_users'}
        $scope.save

    ))

    it('.entryList contains rspecTester', ()->
      $httpBackend.when('GET','/api/ldap_users').respond(mockresArry)
      $scope.init()
      $scope.entryList.$promise.then(
        (successData)->
          console.log(successData)
      )
      $httpBackend.flush()


      console.log($scope.entryList[0])
      expect($scope.entryList.then((win))).toContain(mockQueryResponse)
      console.log($scope.entryList)

      #expect($scope.entryList).toContain(mockQueryResponse)
#      expect($scope.entryList).toContain(mockQueryResponse)
    )
)