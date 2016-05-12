ldapManager = angular.module('ldapManager')

ldapManager.factory 'User', ['$resource', '$http', ($resource, $http)->
  class User
    constructor: (userId)->
      if(angular.isDefined(userId))
        @service = $resource('/api/ldap_users/:id',
          {id: userId},
          {update: {method: 'PATCH'}})
      else 
        @service = $resource('/api/ldap_users')

      # Fix needed for the PATCH method to use application/json content type.
      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'
      
    create: (attrs)->
      new @service(ldapData: attrs).$save (user)->
        attrs.id = user.id
      attrs

    update: (id, attrs)->
      new @service(ldapData: attrs).$update {id: id}

    getUser: ()->
      @service.get()
      
    all: ()->
      @service.query()
]