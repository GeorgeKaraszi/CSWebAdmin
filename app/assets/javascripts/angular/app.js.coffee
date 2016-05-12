ldapManager = angular.module('ldapManager', ['ngAnimate', 'ui.router', 'templates', 'ngResource', 'formBuilder'])

ldapManager.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  ($stateProvider, $urlRouterProvider, $locationProvider)->
    $stateProvider
      .state('ldap_users', { url: '/ldap_users', templateUrl: 'entry/layout.html', controller: 'UserIndexCtrl'})
      .state('ldap_users.show', { url: '/:id/show', templateUrl: 'entry/show.html', controller: 'UserShowCtrl'})
      .state('ldap_users.edit', { url: '/:id/edit', templateUrl: 'entry/edit.html', controller: 'UserEditCtrl'})
      .state('ldap_users.new', { url: '/new', templateUrl: 'entry/new.html', controller: 'UserNewCtrl'})
      .state('ldap_users.destroy', {url: '/:id/destroy', controller: 'UserDestroyCtrl'})

    $stateProvider
      .state('ldap_groups', { url: '/ldap_groups',templateUrl: 'entry/layout.html', controller: 'GroupIndexCtrl'})
      .state('ldap_groups.show', { url: '/:id/show', templateUrl: 'entry/show.html', controller: 'GroupShowCtrl'})
      .state('ldap_groups.edit', { url: '/:id/edit', templateUrl: 'entry/edit.html', controller: 'GroupEditCtrl'})
      .state('ldap_groups.new', { url: '/new', templateUrl: 'entry/new.html', controller: 'GroupNewCtrl'})
      .state('ldap_groups.destroy', {url: '/:id/destroy', controller: 'GroupDestroyCtrl'})
    $locationProvider.html5Mode(true)
])

ldapManager.config(['$httpProvider', ($httpProvider)->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])