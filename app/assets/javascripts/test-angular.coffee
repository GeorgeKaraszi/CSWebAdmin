@app = angular.module('ldapManager', [])

@app.directive 'dynamicForm', ($q, $http, $document, $parse, $templateCache, $compile, $timeout) ->
  field_support =
    'text': {element: 'input', type: 'text', editable: true, textBased: true},
    'textarea': {element: 'input', type: 'textarea', editable: true, textBased: true},
    'email': {element: 'input', type: 'email', editable: true, textBased: true},
    'password': {element: 'input', type: 'password', editable: true, textBased: true},
    'number': {element: 'input', type: 'number', editable: true, textBased: true},
    'checkbox': {element: 'input', type: 'checkbox', editable: true, textBased: false},
    'select': {element: 'select', editable: false, textBased: false},
    'radio': {element: 'div', editable: true, textBased: true},
    'file': {element: 'input', type: 'file', editable: true, textBased: true},
    'hidden': {element: 'input', type: 'hidden', editable: false, textBased: false},
    'submit': {element: 'input', type: 'text', editable: true, textBased: true},

  {
    restrict: 'E',
    link: ($scope, element, attrs) ->

      iterElm = element

      if(angular.isDefined(attrs.ngModel))
        model = $parse(attrs.ngModel)($scope)

        ($http.get('./ldap/test', {cache: $templateCache}).then (results)->
          return results.data
        )
        .then (template) ->
          console.log(template)

          makeLabel = (title) ->
            newLabel = angular.element($document[0].createElement('label'))
            newLabel.addClass(attrs.labelClass) if angular.isDefined(attrs.labelClass)
            newLabel.append(title)
            return newLabel;

          makeFieldContainer = (htmlElement) ->
            newElement = angular.element($document[0].createElement('div'));
            newElement.addClass(attrs.fieldClass) if angular.isDefined(attrs.fieldClass)
            newElement.append(htmlElement)
            return newElement;

          makeRemoveTag = (index) ->
            newRemoveParent = angular.element($document[0].createElement('div'))
            newRemoveParent.addClass(attrs.rmContainerClass) if angular.isDefined(attrs.rmContainerClass)

            newRemoveTag = angular.element($document[0].createElement('span'))
            newRemoveTag.addClass(attrs.removeClass) if angular.isDefined(attrs.removeClass)
            newRemoveTag.append('Remove')
            newRemoveParent.append(newRemoveTag)
            return newRemoveParent;

          makeModel = (fieldId, scope_model)->
            return (scope_model + '[' + fieldId.join("']['") + ']' );


          formBuilder = (entry, id) ->
            console.log('id ->' + id)
            console.log(entry)
            groupElement = angular.element($document[0].createElement('div'));
            groupElement.addClass('form-group')
            if(angular.isDefined(field_support[entry.type]))
              groupElement.append(makeLabel(entry.title))

              newElement = angular.element($document[0].createElement(field_support[entry.type].element))
              console.log('HERE2!')
              newElement.attr('type', field_support[entry.type].type)
              newElement.attr('ng-model', makeModel(entry.key, attrs.ngModel))
              console.log('HERE2!')

              if(entry.type == 'text' || entry.type == 'password' || entry.type == 'number')
                newElement.attr('value', entry.val) if angular.isDefined(entry.val)

              groupElement.append(makeFieldContainer(newElement))
              groupElement.append(makeRemoveTag(id))

            console.log('Appending')
            this.append(groupElement)
            groupElement = null;

          console.log('Appending Start ->' + template)
          angular.forEach(template, formBuilder, element)
          
  }


@app.controller 'FormTest', ($scope, $http) ->
  $scope.fieldList = []

  #
  # Test value to see if its vaild
  ###################################################################################
  angular.isUndefinedOrNull = (val) ->
    return angular.isUndefined(val) || val == null;