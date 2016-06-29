describe('entryCtrlShow', ()->

  beforeEach(module('ldapManager'))

  #Global variables
  $scope = undefined
  $httpBackend = undefined
  Crud = undefined

  #Testing Mock information
  mockQueryResponse = {
    dn:"uid=rspecTester,ou=People,dc=test",
    cn:"rspecTester",
    attributes: {
      uid: 'rspecTester',
      uidNumber: '9999',
      givenName: 'Go Old Boy'
    }}

  #The setup
  beforeEach(inject(($injector)->
    #Gather mock objects
    $state       = $injector.get('$state')
    stateParms   = $injector.get('$stateParams')
    $httpBackend = $injector.get('$httpBackend')
    $scope       = $injector.get('$rootScope').$new()
    Crud         = $injector.get('Crud')
    controller   = $injector.get('$controller')


    stateParms.id = mockQueryResponse.dn

    #Initialize the controller to the new scope
    controller('EntryShowCtrl', { $scope: $scope, $stateParams: stateParms, Crud: Crud })

    #Monitor CRUD functions
    spyOn(Crud, 'get').and.callThrough();

    #Assign the given route state of the object(Used by Crud to assign API URLS)
    $state.current = {controller:'EntryShowCtrl', name:'ldap_users'}

    #Setup mock HTTP backend response once called
    $httpBackend.when('GET','/api/ldap_users/'+ mockQueryResponse.dn).respond(data: mockQueryResponse)

    $scope.save
    $scope.init()

  ))

  describe('Crud', ()->
    it('.get was called', ()->
      expect(Crud.get).toHaveBeenCalled()
    )

    it('.get() was called with id', ()->
      expect(Crud.get).toHaveBeenCalledWith(mockQueryResponse.dn)
    )
  )

  describe('.entryData', ()->
    it('contains rspecTester and attributes', ()->
      $httpBackend.flush()
      expect($scope.entryData.data).toEqual(mockQueryResponse)
    )
  )

)