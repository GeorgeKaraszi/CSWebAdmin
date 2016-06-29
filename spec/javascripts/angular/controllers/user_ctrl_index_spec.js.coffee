describe('userCtrlIndex', ()->

    beforeEach(module('ldapManager'))

    $scope = undefined
    $httpBackend = undefined
    Crud = undefined
    mockQueryResponse = [{dn:"uid=rspecTester,ou=People,dc=test",cn:"rspecTester",idNum:99999},
                         {dn:"uid=rspecTester2,ou=People,dc=test",cn:"rspecTester2",idNum:23423}]

    beforeEach(inject(($injector)->
        #Gather mock objects
        $state       = $injector.get('$state')
        $httpBackend = $injector.get('$httpBackend')
        $scope       = $injector.get('$rootScope').$new()
        Crud         = $injector.get('Crud')
        controller   = $injector.get('$controller')

        #Initialize the controller to the new scope
        controller('UserIndexCtrl', { $scope: $scope, Crud: Crud })

      #Monitor CRUD functions
        spyOn(Crud, 'all').and.callThrough();
        
        #Assign the given route state of the object(Used by Crud to assign API URLS)
        $state.current = {controller:'UserIndexCtrl', name:'ldap_users'}

        #Setup mock HTTP backend response once called
        $httpBackend.when('GET','/api/ldap_users').respond([data: mockQueryResponse])

        $scope.save
        $scope.init()

    ))

    describe('Crud', ()->
      it('.all() was called', ()->
        expect(Crud.all).toHaveBeenCalled()
      )

      it('called .all() with no parameters',()->
        expect(Crud.all).toHaveBeenCalledWith()
      )

    )
    describe('.entryList', ()->
      it('contains rspecTester & rspecTester2', ()->
        $httpBackend.flush()
        expect($scope.entryList[0].data).toEqual(mockQueryResponse)
      )
    )

)