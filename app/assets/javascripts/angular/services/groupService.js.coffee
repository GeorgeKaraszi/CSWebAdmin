ldapManager = angular.module('ldapManager')

ldapManager.factory 'Group', ['$resource', '$http', ($resource, $http)->
  class Group
    constructor: (groupId)->
      if(angular.isDefined(groupId))
        @service = $resource('/api/ldap_groups/:id',
          {id: groupId},
          {update: {method: 'PATCH'}})
      else
        @service = $resource('/api/ldap_groups')

      # Fix needed for the PATCH method to use application/json content type.
      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'

    create: (attrs)->
      new @service(user: attrs).$save (user)->
        attrs.id = user.id
      attrs

    update: (id, attrs)->
      new @service(ldapData: attrs).$update {id: id}

    delete: (id)->
      new @service.$delete {id: id}

    getGroup: ()->
      @service.get()

    all: ()->
      @service.query()
]