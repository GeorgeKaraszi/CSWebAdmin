#@app = angular.module('', [])
#
#@app.controller 'FormCtrl', ($scope, $http) ->
#  $scope.currentAttributes = []
#  $scope.currentAttributesVisible = {}
#  $scope.fieldList = []
#
#
#  #
#  # Test value to see if its vaild
#  ###################################################################################
#  angular.isUndefinedOrNull = (val) ->
#    return angular.isUndefined(val) || val == null;
#
#
#  #
#  # Find a matching attribute in a hash and return that hash/s that were found
#  ###################################################################################
#  $scope.FindMatchingHash = (hashArray, key, value, exception, deleteMatch = false)->
#    returnValue = []
#
#    angular.forEach(hashArray, (item)->
#      if(item[key] && item[key] == value && item['keyattribute'] != exception)
#        returnValue.push(item)
#    )
#
#    if deleteMatch == true
#      angular.forEach(returnValue, (item)->
#        hashArray.splice(hashArray.indexOf(item), 1)
#      )
#
#    return returnValue
#
#
#  #
#  # Search an array of hash for an attibute that is sharred between the target
#  # and index of list
#  ###################################################################################
#  $scope.RemoveHash = (list, attributeName, target) ->
#    returnValue = {}
#
#    angular.forEach(list, (item) ->
#      if(item[attributeName] && item[attributeName] == target[attributeName])
#        returnValue = item
#    )
#
#    list.splice(list.indexOf(returnValue), 1) unless returnValue == null
#    return returnValue
#
#
#  #
#  # Get a list of attributes that have not yet been defined. (AJAX Request)
#  ###################################################################################
#  $http.get('./ldap/request').success((data) ->
#
#    currentAttributes   = data["current"]
#    availableAttributes = data["available"]
#
#    $scope.currentAttributes = currentAttributes
#    angular.forEach(currentAttributes, (item)->
#      $scope.currentAttributesVisible[item['keyattribute']] = []
#      angular.forEach(item['values'], (element)->
#        $scope.currentAttributesVisible[item['keyattribute']].push(true)
#      )
#    )
#
#    $scope.fieldList = $scope.FindMatchingHash(availableAttributes, 'required', true, 'ObjectClass', true)
#    $scope.availableList = availableAttributes
#  ).error((data, status) ->
#    console.log('error')
#  )
#
#
#  #
#  # Action: Click event
#  # Removes an attribute that is in the LDAP system already. Then adds the
#  # attribute to the avaiable attribute list
#  ###################################################################################
#  $scope.removePresetField = (key, index)->
#    console.log('key=' + key + ' index = ' + index)
#    $scope.currentAttributesVisible[key][index] = false
#    angular.forEach($scope.currentAttributes, (item)->
#      if(item['keyattribute'] == key)
#        item.values[index] = ''
#        $scope.availableList.push(item)
#    )
#
#
#  #
#  # Action: Click event
#  # Take the option from the select menu, then add it to the avabilie field list
#  ###################################################################################
#  $scope.addField = ->
#    return if angular.isUndefinedOrNull($scope.selectedField)
#
#    item = $scope.RemoveHash($scope.availableList, 'keyattribute', $scope.selectedField)
#    $scope.fieldList.push(item)
#
#  #
#  # Removes a field attribute and places the removed field back into the avaible list
#  ##################################################################################
#  $scope.removeField = (x)->
#    $scope.availableList.push($scope.fieldList[x])
#    $scope.fieldList.splice(x, 1)