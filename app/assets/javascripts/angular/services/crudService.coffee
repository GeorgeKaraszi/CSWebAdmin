ldapManager = angular.module('ldapManager')

ldapManager.factory 'Crud', ['$resource', '$http', '$state', 'Notice',
  ($resource, $http, $state, Notice)->
    class Group
      constructor: (id)->
        
        #Obtain the parent (EX: ldap_users.show = ldap_users)
        controllerPath = $state.current.name.split('.')[0]
        console.log(controllerPath)

        if(angular.isDefined(id))
          @service = $resource('/api/'+ controllerPath + '/:id',
            {id: id},
            {update: {method: 'PATCH'}})
        else
          @service = $resource('/api/' + controllerPath)

        # Fix needed for the PATCH method to use application/json content type.
        defaults = $http.defaults.headers
        defaults.patch = defaults.patch || {}
        defaults.patch['Content-Type'] = 'application/json'

      create: (attrs)->
        new @service(ldapData: attrs).$save (
          (sucessResults)->
            console.log(sucessResults)
            Notice.SetMessage(sucessResults.notice, 1)
            $state.go('^.show', {id: sucessResults.id}, {reload: true})
        ),(rejectResults)->
            Notice.SetMessage(rejectResults.notice, 1)

      update: (id, attrs)->
        errorMessage = undefined
        new @service(ldapData: attrs).$update({id: id}).then(
          (sucessResults)->
            Notice.SetMessage(sucessResults.notice, 1)
            $state.go('^.show', {id: id}, {reload: true})

          ,(rejectResults)->
            console.log(rejectResults.data)
            Notice.SetMessage(rejectResults.data.notice, 1)
            console.log('placeholder')

        )

      delete: (id)->
        new @service().$delete {id: id},
          (sucessResults)->
            Notice.SetMessage(sucessResults.notice, 1)
            console.log(sucessResults)
            $state.go('^')
          ,(rejectResults)->
            Notice.SetMessage(rejectResults.notice, 1)
            $state.go('^')


      get: ()->
        @service.get()

      all: ()->
        @service.query()
]