describe('userCtrlDestroy', ()->

  beforeEach(module('ldapManager'))

  #Global variables
  $scope = undefined
  $state = undefined
  $httpBackend = undefined
  $controller = undefined
  Crud = undefined
  Notice = undefined

  #Testing Mock information
  id = "uid=rspecTester,ou=People,dc=test"

  mockGoodQueryResponse = {notice: 'user has been deleted'}
  mockBadQueryResponse = {notice: 'user has not been deleted'}

  #The setup
  beforeEach(inject(($injector)->
#Gather mock objects
    $state       = $injector.get('$state')
    stateParms   = $injector.get('$stateParams')
    $httpBackend = $injector.get('$httpBackend')
    $scope       = $injector.get('$rootScope').$new()
    Crud         = $injector.get('Crud')
    Notice       = $injector.get('Notice')
    $controller   = $injector.get('$controller')

    stateParms.id = id

    #Monitor CRUD functions
    spyOn(Crud, 'delete').and.callThrough();
    spyOn($state, 'go').and.callFake(()->
      $state.current = {controller:'UserIndexCtrl', name:'ldap_users', url:'/'}
    );


    #Assign the given route state of the object(Used by Crud to assign API URLS)
    $state.current = {controller:'UserNewCtrl', name:'ldap_users', url:'/new'}

    #Setup mock HTTP backend response once called
    $httpBackend.expect('DELETE','/api/ldap_users/' + id).respond(200, mockGoodQueryResponse)


    #Initialize the controller to the new scope
    $controller('UserDestroyCtrl', { $scope: $scope, Crud: Crud })

    $httpBackend.flush()

  ))

  describe('CRUD', ()->

    it('should hve called .delete() ', ()->
      expect(Crud.delete).toHaveBeenCalled()
    )

    it('called .delete with id ', ()->
      expect(Crud.delete).toHaveBeenCalledWith(id)
    )

    it('should have called new $state', ()->
      expect($state.go).toHaveBeenCalled()
      expect($state.go).toHaveBeenCalledWith('^')
    )

    it('state.current.url should be /', ()->
      expect($state.current.url).toEqual('/')
    )
  )

  describe('.notice', ()->
    it('contains a successful message', ()->
      expect(Notice.GetMessage()).toEqual(mockGoodQueryResponse.notice)
    )

    it('contains an error message', ()->
      $httpBackend.expect('DELETE','/api/ldap_users/' + id).respond(422, mockBadQueryResponse)
      $controller('UserDestroyCtrl', { $scope: $scope, Crud: Crud })
      $httpBackend.flush()
      
      expect(Notice.GetMessage()).toEqual(mockBadQueryResponse.notice)
    )
  )
)