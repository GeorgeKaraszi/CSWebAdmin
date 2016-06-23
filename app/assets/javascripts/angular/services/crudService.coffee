ldapManager = angular.module('ldapManager')

ldapManager.factory 'Crud', ['$resource', '$http', '$state', 'Notice',
  ($resource, $http, $state, Notice)->
    @id = undefined
    @service = undefined
    return {
      init: (id)->
        #Obtain the parent (EX: ldap_users.show = ldap_users)
        controllerPath = $state.current.name.split('.')[0]
        if(angular.isDefined(id))
          @id = id
          @service = $resource('/api/' + controllerPath + '/:id',
            {id: id},
            {update: {method: 'PATCH'}})
        else
          @service = $resource('/api/' + controllerPath)

        # Fix needed for the PATCH method to use application/json content type.
        defaults = $http.defaults.headers
        defaults.patch = defaults.patch || {}
        defaults.patch['Content-Type'] = 'application/json'
        return this

      create: (attrs)->
        this.init()
        new @service(ldapData: attrs).$save {},
          (sucessResults)->
            Notice.SetMessage(sucessResults.notice, 1)
            $state.go('^.show', {id: sucessResults.id})

        , (rejectResults)->
          Notice.SetMessage(rejectResults.data.notice, 1)


      update: (id, attrs)->
        this.init(id)
        new @service(ldapData: attrs).$update {},
          (sucessResults)->
            Notice.SetMessage(sucessResults.notice, 1)
            $state.go('^.show', {id: sucessResults.id})

        , (rejectResults)->
          Notice.SetMessage(rejectResults.data.notice, 1)

      delete: (id)->
        this.init(id)
        new @service().$delete {},
          (sucessResults)->
            Notice.SetMessage(sucessResults.notice, 1)
            $state.go('^')

        , (rejectResults)->
          Notice.SetMessage(rejectResults.data.notice, 1)
          $state.go('^')


      get: (id)->
        this.init(id)
        @service.get()

      all: (id)->
        this.init(id)
        @service.query()
    }
]