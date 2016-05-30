describe('userCtrlNew', ()->

  beforeEach(module('ldapManager'))

  #Global variables
  $scope = undefined
  $state = undefined
  $httpBackend = undefined
  Crud = undefined

  #Testing Mock information
  id = "uid=rspecTester,ou=People,dc=test"
  mockQueryData = {
    dn:"uid=rspecTester,ou=People,dc=test",
    cn:"rspecTester",
    attributes: {
      uid: 'rspecTester',
      uidNumber: '9999',
      givenName: 'Go Old Boy'
    }}

  mockGoodQueryResponse = {notice: 'successful query', id:id}
  mockBadQueryResponse = {notice: 'bad query'}

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
    controller('UserNewCtrl', { $scope: $scope, Crud: Crud })

    #Monitor CRUD functions
    spyOn(Crud, 'create').and.callThrough();
    spyOn($state, 'go').and.callFake(()->
      $state.current = {controller:'UserShowCtrl', name:'ldap_users', url:'/:id/show'}
    );

    #Assign the given route state of the object(Used by Crud to assign API URLS)
    $state.current = {controller:'UserNewCtrl', name:'ldap_users', url:'/new'}

    #Setup mock HTTP backend response once called
    $httpBackend.expect('POST','/api/ldap_users').respond(200, mockGoodQueryResponse)

    $scope.ldapForm = mockQueryData

    $scope.save
    $scope.init()
    $scope.submit()
    $httpBackend.flush()

  ))

  describe('CRUD', ()->

    it('should hve called .create() ', ()->
      expect(Crud.create).toHaveBeenCalled()
    )

    it('called .create was called with ldapForm ', ()->
      expect(Crud.create).toHaveBeenCalledWith(mockQueryData)
    )

    it('should have called new $state', ()->
      expect($state.go).toHaveBeenCalled()
      expect($state.go).toHaveBeenCalledWith('^.show', {id: id})
    )

    it('state.current.url should be /:id/show', ()->
      expect($state.current.url).toEqual('/:id/show')
    )
  )

  describe('.notice', ()->
    it('contains a successful message', ()->
      expect($scope.notice).toEqual(mockGoodQueryResponse.notice)
    )

    it('contains an error message', ()->
      $httpBackend.expect('POST','/api/ldap_users').respond(422, mockBadQueryResponse)
      $scope.submit()
      $httpBackend.flush()

      expect($scope.notice).toEqual(mockBadQueryResponse.notice)
    )
  )
)