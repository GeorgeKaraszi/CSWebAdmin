@app = angular.module('ldapManager', [])

@app.controller 'FormCtrl', ($scope, $http) ->
  $http.get('./export.json').success((data) ->
    $scope.availableList = data
  )

  $scope.fieldList = []

  angular.isUndefinedOrNull = (val) ->
    return angular.isUndefined(val) || val == null;

  $scope.RemoveHash = (list, attributeName, target) ->
    returnValue = {}

    angular.forEach(list, (item) ->
      if(item[attributeName] && item[attributeName] == target[attributeName])
        returnValue = item
    )

    list.splice(list.indexOf(returnValue), 1) unless returnValue == null
    return returnValue

  $scope.addField = ->
    if angular.isUndefinedOrNull($scope.selectedField)
      return;

    item = $scope.RemoveHash($scope.availableList, 'keyattribute', $scope.selectedField)
    $scope.fieldList.push(item)