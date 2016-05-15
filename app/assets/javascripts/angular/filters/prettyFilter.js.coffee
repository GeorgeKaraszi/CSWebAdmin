angular.module('ldapManager').filter 'pretty', ->
  return (input) ->
    temp = undefined
    try
      temp = angular.fromJson(input)
    catch e
      temp = input

    angular.toJson temp, true