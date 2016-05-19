ldapManager = angular.module('ldapManager')

ldapManager.factory 'Notice', ['$rootScope', ($rootScope)->
  return{
    init: ()->
      $rootScope.noticeSys = {displayed: 0, message: '', msg_type: ''}
      return true

    GetMessage: ()->

      if angular.isDefined($rootScope.noticeSys)
        if $rootScope.noticeSys.displayed < 2
          $rootScope.noticeSys.displayed += 1 #UI -ROUTE error crappy fix. Controller is called twice.
          return $rootScope.noticeSys.message;

      return undefined

    SetMessage: (message, msg_type)->
      $rootScope.noticeSys = {displayed: false, message: message, msg_type: msg_type}
      return true
  }
]