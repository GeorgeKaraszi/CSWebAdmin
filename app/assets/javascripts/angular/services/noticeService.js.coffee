ldapManager = angular.module('ldapManager')

ldapManager.factory 'Notice', ['$rootScope', ($rootScope)->
  return{
    init: ()->
      $rootScope.notice = {displayed: true, message: '', msg_type: ''}
      return true

    Message: ()->

      if angular.isDefined($rootScope.notice)
        unless $rootScope.notice.displayed
          $rootScope.notice.displayed = true
          return $rootScope.notice.message;

      return undefined

    SetMessage: (message, msg_type)->
      $rootScope.notice = {displayed: false, message: message, msg_type: msg_type}
      return true
  }
]