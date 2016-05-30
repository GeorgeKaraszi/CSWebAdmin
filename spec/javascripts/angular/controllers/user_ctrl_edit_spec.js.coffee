describe('userCtrlEdit', ()->

  beforeEach(module('ldapManager'))

  #Global variables
  $scope = undefined
  $state = undefined
  $httpBackend = undefined
  Crud = undefined

  #Testing Mock information
  id = "uid=rspecTester,ou=People,dc=test"
  mockGetQueryResponse = {
    dn:"uid=rspecTester,ou=People,dc=test",
    cn:"rspecTester",
    attributes: {
      uid: 'rspecTester',
      uidNumber: '9999',
      givenName: 'Go Old Boy'
    }}

  mockGoodQueryResponse = {notice: 'successful query', id:id}
  mockBadQueryResponse = {notice: 'missing loginPath'}

  #The setup
  beforeEach(inject(($injector)->
    #Gather mock objects
    $state       = $injector.get('$state')
    stateParms   = $injector.get('$stateParams')
    $httpBackend = $injector.get('$httpBackend')
    $scope       = $injector.get('$rootScope').$new()
    Crud         = $injector.get('Crud')
    controller   = $injector.get('$controller')

    stateParms.id = id
    
    #Initialize the controller to the new scope
    controller('UserEditCtrl', { $scope: $scope, $stateParams: stateParms, Crud: Crud })

    #Monitor CRUD functions
    spyOn(Crud, 'get').and.callThrough();
    spyOn(Crud, 'update').and.callThrough();
    spyOn($state, 'go').and.callFake(()->
        $state.current = {controller:'UserShowCtrl', name:'ldap_users', url:'/:id/show'}
    );

    #Assign the given route state of the object(Used by Crud to assign API URLS)
    $state.current = {controller:'UserEditCtrl', name:'ldap_users', url:'/:id/edit'}

    #Setup mock HTTP backend response once called
    $httpBackend.when('GET','/api/ldap_users/'+ id).respond(data: mockGetQueryResponse)
    $httpBackend.expect('PATCH','/api/ldap_users/'+ id).respond(200, mockGoodQueryResponse)

    $scope.ldapForm = mockGetQueryResponse

    $scope.save
    $scope.init()
    $scope.submit()
    $httpBackend.flush()

  ))

  describe('CRUD', ()->

    it('was called with .get(id)', ()->
      expect(Crud.get).toHaveBeenCalled()
      expect(Crud.get).toHaveBeenCalledWith(id)
    )

    it('should hve called .update() ', ()->
      expect(Crud.update).toHaveBeenCalled()
    )

    it('called .update(id, ldapForm) ', ()->
      expect(Crud.update).toHaveBeenCalledWith(id, mockGetQueryResponse)
    )

    it('should have called new $state', ()->
      expect($state.go).toHaveBeenCalled()
      expect($state.go).toHaveBeenCalledWith('^.show', {id: id}, {reload: true})
    )

    it('state.current.url should be /:id/show', ()->
      expect($state.current.url).toEqual('/:id/show')
    )
  )

  describe('.entryData', ()->
    it('contains rspecTester and attributes', ()->
      expect($scope.entryData.data).toEqual(mockGetQueryResponse)
    )
  )

  describe('.notice', ()->
    it('contains a successful message', ()->
      expect($scope.notice).toEqual(mockGoodQueryResponse.notice)
    )

    it('contains an error message', ()->
      $httpBackend.expect('PATCH','/api/ldap_users/'+ id).respond(422, mockBadQueryResponse)
      $scope.submit()
      $httpBackend.flush()

      expect($scope.notice).toEqual(mockBadQueryResponse.notice)
    )
  )
)