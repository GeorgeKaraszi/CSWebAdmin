describe('userCtrl', ()->

    beforeEach(module('ldapManager'))

    scope = undefined
    beforeEach(inject(($rootScope, $controller)->
        scope = $rootScope.$new()
        $controller('UserIndexCtrl', {$scope: scope})
    ))

    beforeEach(inject(($controller, _$rootScope_, Notice, Crud)->
        scope = _$rootScope_.$new()
        $controller('UserIndexCtrl', {$scope: scope})
        scope.init()
    ))

    describe('.entryList', ()->
        it 'contains data', ()->
            console.log(scope)
            console.log(scope.message)
            expect(scope.entryIdName).toEqual('UID')
    )
)