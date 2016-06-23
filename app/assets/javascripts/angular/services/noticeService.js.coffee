ldapManager = angular.module('ldapManager')

ldapManager.factory 'Notice', ['$rootScope', '$state', ($rootScope, $state)->
  return{
    init: ()->
      $rootScope.noticeSys = {displayed: 0, message: '', msg_type: ''}
      return this

    GetMessage: ()->
      if angular.isDefined($rootScope.noticeSys)
        if $rootScope.noticeSys.displayed < 2
          $rootScope.noticeSys.displayed += 1 #UI -ROUTE error crappy fix. Controller is called twice.
        return $rootScope.noticeSys.message;

      return undefined

    SetMessage: (message, msg_type, nxt_state = true)->
      #temporary soultion, this will be exapaned to become more formatted later on
      if angular.isArray(message)
        $rootScope.noticeSys = {
          displayed: 0,
          message: message[0], 
          msg_type: msg_type
        }
      else
        $rootScope.noticeSys = {
          displayed: 0,
          message: message,
          msg_type: msg_type
        }
      return true
  }
]