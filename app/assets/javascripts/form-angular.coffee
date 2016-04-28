@app = angular.module('ldapManager', [])

@app.controller 'FormCtrl', ($scope, $http) ->

  $scope.presetFieldList = []
  $scope.fieldList = []

  #
  # Test value to see if its vaild
  ###################################################################################
  angular.isUndefinedOrNull = (val) ->
    return angular.isUndefined(val) || val == null;


  #
  # Find a matching attribute in a hash and return that hash/s that were found
  ###################################################################################
  $scope.FindMatchingHash = (hashArray, key, value, exception, deleteMatch = false)->
    returnValue = []

    angular.forEach(hashArray, (item)->
      if(item[key] && item[key] == value && item['keyattribute'] != exception)
        returnValue.push(item)
    )

    if deleteMatch == true
      angular.forEach(returnValue, (item)->
        hashArray.splice(hashArray.indexOf(item), 1)
      )

    console.log('Return: ' + returnValue)
    return returnValue


  #
  # Search an array of hash for an attibute that is sharred between the target
  # and index of list
  ###################################################################################
  $scope.RemoveHash = (list, attributeName, target) ->
    returnValue = {}

    angular.forEach(list, (item) ->
      if(item[attributeName] && item[attributeName] == target[attributeName])
        returnValue = item
    )

    list.splice(list.indexOf(returnValue), 1) unless returnValue == null
    return returnValue


  #
  # Get a list of attributes that have not yet been defined. (AJAX Request)
  ###################################################################################
  $http.get('./db/export').success((data) ->
    console.log(data)
    $scope.fieldList = $scope.FindMatchingHash(data, 'required', true, 'ObjectClass', true)
    $scope.availableList = data
  ).error((data,status) ->
    console.log('error')
  )

  #
  # Action: Click event
  # Take the option from the select menu, then add it to the avabilie field list
  #
  ###################################################################################
  $scope.addField = ->
    return if angular.isUndefinedOrNull($scope.selectedField)

    item = $scope.RemoveHash($scope.availableList, 'keyattribute', $scope.selectedField)
    $scope.fieldList.push(item)

  #
  # Removes a field attribute and places the removed field back into the avaible list
  ##################################################################################
  $scope.removeField = (x)->
    $scope.availableList.push($scope.fieldList[x])
    $scope.fieldList.splice(x, 1)