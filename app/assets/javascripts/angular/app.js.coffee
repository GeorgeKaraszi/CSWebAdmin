ldapManager = angular.module('ldapManager', ['ngAnimate', 'ui.router', 'templates'])

ldapManager.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  ($stateProvider, $urlRouterProvider, $locationProvider)->

    console.log('here')

    $stateProvider
      .state('ldap_users', { url: '/ldap_users',templateUrl: 'entry/layout.html', controller: 'UserIndexCtrl'})
      .state('ldap_users.show', { url: '/:id/show', templateUrl: 'entry/show.html', controller: 'UserShowCtrl'})
      .state('ldap_users.edit', { url: '/:id/edit', templateUrl: 'entry/edit.html', controller: 'UserEditCtrl'})
      .state('ldap_users.new', { url: '/new', templateUrl: 'entry/new.html', controller: 'UserNewCtrl'})

    $locationProvider.html5Mode(true)
])