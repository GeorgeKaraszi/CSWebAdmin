@app = angular.module('ldapManager', [])

@app.directive 'dynamicForm', ($q, $http, $document, $parse, $templateCache, $compile, $timeout, $filter) ->
  field_support =
    'text': {element: 'input', type: 'text', editable: true, textBased: true, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'textarea': {element: 'input', type: 'textarea', editable: true, textBased: true, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'email': {element: 'input', type: 'email', editable: true, textBased: true, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'password': {element: 'input', type: 'password', editable: true, textBased: true, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'number': {element: 'input', type: 'number', editable: true, textBased: true, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'checkbox': {element: 'input', type: 'checkbox', editable: true, textBased: false, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'select': {element: 'select', editable: false, textBased: false, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'radio': {element: 'div', editable: true, textBased: true, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'file': {element: 'input', type: 'file', editable: true, textBased: true, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'hidden': {element: 'input', type: 'hidden', editable: false, textBased: false, fieldClass: 'form-control', containerClass: 'col-sm-5'},
    'submit': {element: 'input', type: 'text', editable: true, textBased: true, fieldClass: 'form-control', containerClass: 'col-sm-5'},

  {
    restrict: 'E',
    link: ($scope, element, attrs) ->
      iterElm = element

      if(angular.isDefined(attrs.ngModel) && angular.isDefined(attrs.activeModel) &&
         angular.isDefined(attrs.inactiveModel) && angular.isDefined(attrs.documentModel))
        model = $parse(attrs.ngModel)($scope)
        activeModel = $parse(attrs.activeModel)($scope)
        inactiveModel = $parse(attrs.inactiveModel)($scope)
        documentModel = $parse(attrs.documentModel)($scope)

        ($http.get('./ldap/test', {cache: $templateCache}).then (results)->
          return results.data
        )
        .then (template) ->
          console.log(template)

          setProperty = (obj, key, value, buildParent)->
            if(buildParent)
              foobar = obj[key]
              foobar[value] = value
            else if(!angular.isDefined(value))
              console.log('Value-> ' + value)
              #obj['new'] = {} unless angular.isDefined(obj['new'])
              console.log('in the new')
            else
              obj[key] = value unless angular.isDefined(obj[key])

          setModelProperty = (obj, entry, htmlEntry)->
            obj[entry.key] = {} unless angular.isDefined(obj[entry.key])
            foo = obj[entry.key]
            foo.id = entry
            foo.htmlEntry = angular.copy(htmlEntry)

          setModelController = (entry, htmlGroup)->
            if !angular.isDefined(entry.val) && entry.required == false
              setModelProperty(inactiveModel, entry, htmlGroup)
              return false;
            else if (entry.key == 'ObjectClass' && !angular.isDefined(entry.val))
              hasActiveField = false;
              objFilter = $filter('filter')(template, {key: entry.key})

              angular.forEach(objFilter, (item)->
                if(angular.isDefined(item.val))
                  hasActiveField = true;
              )
              if(hasActiveField)
                setModelProperty(inactiveModel, entry, htmlGroup)
                return false;


            setModelProperty(activeModel, entry, htmlGroup)
            return true;


          makeLabel = (title) ->
            newLabel = angular.element($document[0].createElement('label'))
            newLabel.addClass(attrs.labelClass) if angular.isDefined(attrs.labelClass)
            newLabel.append(title)
            return newLabel;

          makeFieldContainer = (htmlElement, entry) ->
            newElement = angular.element($document[0].createElement('div'));

            if angular.isDefined(attrs.fieldClass)
              newElement.addClass(attrs.fieldClass)
            else
              newElement.addClass(field_support[entry.type].containerClass)

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

          makeModel = (scope_model, fieldId, val)->
            if angular.isDefined(val)
              return (scope_model + "['" + fieldId + "']" + "['" + val + "']")
            else
              return (scope_model + "['new']['" + fieldId + "']" )


          formBuilder = (entry, id) ->
            groupElement = angular.element($document[0].createElement('div'));
            groupElement.addClass('form-group')
            if(angular.isDefined(field_support[entry.type]))
              entry.model = id
              groupElement.append(makeLabel(entry.title))

              newElement = angular.element($document[0].createElement(field_support[entry.type].element))
              newElement.addClass(field_support[entry.type].fieldClass)
              newElement.attr('type', field_support[entry.type].type)
              newElement.attr('ng-model', makeModel(attrs.ngModel, entry.key, entry.val))
              setProperty(model, entry.key, {}, false)

              if(entry.type == 'text' || entry.type == 'password' || entry.type == 'number')
                if angular.isDefined(entry.val)
                  newElement.attr('value', entry.val)
                  setProperty(model, entry.key, entry.val, true)
                else
                  setProperty(model, entry.key, undefined, false)

              groupElement.append(makeFieldContainer(newElement, entry))
              groupElement.append(makeRemoveTag(id))


            this.append(groupElement) if setModelController(entry, groupElement)
            groupElement = null;


          angular.forEach(template, formBuilder, element)


          newElement = angular.element($document[0].createElement('div'))
          newElement.attr('model', attrs.ngModel);
          newElement.removeAttr('ng-model');
          #newElement.data('$_cleanModel', angular.copy(model));

          angular.forEach(element[0].classList, (clsName)->
            newElement[0].classList.add(clsName);
          )
          newElement.addClass('dynamic-form');
          newElement.append(element.contents());



          $compile(newElement)($scope)
          element.replaceWith(newElement)
          documentModel.element = newElement;



  }


@app.controller 'FormTest', ($scope, $http, $compile) ->
  $scope.activeFields = {}
  $scope.inactiveFields = {}
  $scope.userData = {}
  $scope.documentModel = {}

  $scope.appendData = ()->
    $scope.documentModel.element.append($scope.inactiveFields['ObjectClass'].htmlEntry)
    $('dynamic-form').append($scope.inactiveFields['ObjectClass'].htmlEntry)
    $compile($scope.documentModel.element)($scope)
    #foo_key = $scope.inactiveFields['ObjectClass'].id.key
    #foo = $scope.userData.new = {} unless angular.isDefined($scope.userData.new)
    #foo[foo_key] = ''


@app.filter 'pretty', ->
  return (input) ->
    temp = undefined
    try
      temp = angular.fromJson(input)
    catch e
      temp = input

    angular.toJson temp, true