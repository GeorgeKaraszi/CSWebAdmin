@app = angular.module('ldapManager', ['ngResource','formbuilder'])

@app.config(['$locationProvider', ($locationProvider)->
  $locationProvider.html5Mode({
    enabled: true,
    requireBase: false});
])

@app.controller 'FormTest', ['$scope', '$http', '$window', ($scope, $http, $window) ->
  $scope.ldapEntry = {}
  $scope.form_method = 'POST'

  $scope.FormMethod = (index)->
    switch index
      when 'edit' then $scope.form_method = 'PATCH'
      when 'new' then $scope.form_method = 'POST'
      else $scope.form_method = 'GET'


  $scope.submitForm = ()->

    console.log('We are here')
    console.log('Here we are again')
    console.log($scope.form_method)
    $http({
      method: $scope.form_method,
      url: '.',
      data: {ldapEntry: $scope.ldapEntry},
      header: 'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8;'
    }).then(
      (response)->
        console.log('win!')
        console.log(response.data.path)
        $window.location.href = response.data.path
    ,
      (response)->
        console.log('LOSE!')
        console.log(response)
    )
]


@app.filter 'pretty', ->
  return (input) ->
    temp = undefined
    try
      temp = angular.fromJson(input)
    catch e
      temp = input

    angular.toJson temp, true