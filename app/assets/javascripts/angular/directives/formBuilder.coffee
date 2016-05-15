@app = angular.module('formBuilder', ['ngResource'])

@app.directive 'dynamicForm', ['$q', '$http', '$document', '$parse', '$templateCache', '$compile', '$filter',
  ($q, $http, $document, $parse, $templateCache, $compile, $filter) ->
    field_support =
      'text': {
        element: 'input',
        type: 'text',
        editable: true,
        textBased: true,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'textarea': {
        element: 'input',
        type: 'textarea',
        editable: true,
        textBased: true,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'email': {
        element: 'input',
        type: 'email',
        editable: true,
        textBased: true,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'password': {
        element: 'input',
        type: 'password',
        editable: true,
        textBased: true,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'number': {
        element: 'input',
        type: 'number',
        editable: true,
        textBased: true,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'checkbox': {
        element: 'input',
        type: 'checkbox',
        editable: true,
        textBased: false,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'select': {
        element: 'select',
        editable: false,
        textBased: false,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'radio': {
        element: 'div',
        editable: true,
        textBased: true,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'file': {
        element: 'input',
        type: 'file',
        editable: true,
        textBased: true,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'hidden': {
        element: 'input',
        type: 'hidden',
        editable: false,
        textBased: false,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      },
      'submit': {
        element: 'input',
        type: 'text',
        editable: true,
        textBased: true,
        fieldClass: 'form-control',
        containerClass: 'col-sm-5'
      }
    {
      restrict: 'E',
      link: ($scope, element, attrs) ->

        $scope.active_fields = {}
        $scope.inactive_fields = {}
        $scope.selectedField = {}

        if(!angular.isDefined(attrs.ngModel) || !angular.isDefined(attrs.templateUrl))
          console.log('Error: Require ng-model and template-url properties')
          return false

        templateUrl = $parse(attrs.templateUrl)($scope)
        model = $parse(attrs.ngModel)($scope)


        ($http.get(templateUrl, {cache: $templateCache}).then (results)->
            return results.data
        ).then (template)->

          #
          # Creates and assigns values to a given model. These are nessary for outside
          # controllers that will handel data, to be initalized before a DOM $compile is
          # issued. Otherwise spawned field models will not update.
          #################################################################################
          setProperty = (obj, key, value, buildParent)->
            if(buildParent)
              obj[key] = {} unless angular.isDefined(obj[key])
              foobar = obj[key]
              foobar[value] = value
            else #if(!angular.isDefined(value))
              obj['new'] = {} unless angular.isDefined(obj['new'])
              obj['new'][key] = value

          #
          # Creats a HTML label element with the (entries) title attribute
          #################################################################################
          makeLabel = (entry) ->
            newLabel = angular.element($document[0].createElement('label'))
            newLabel.addClass(attrs.labelClass) if angular.isDefined(attrs.labelClass)
            newLabel.append(entry.title)

            return newLabel;

          #
          # Creates a div container surrounding the custom field, W/CSS class attributes,
          # to better fit a customized form criteria
          #################################################################################
          makeFieldContainer = (htmlElement, entry) ->
            newElement = angular.element($document[0].createElement('div'));

            if angular.isDefined(attrs.fieldClass)
              newElement.addClass(attrs.fieldClass)
            else
              newElement.addClass(field_support[entry.type].containerClass)

            newElement.append(htmlElement)

            return newElement;

          #
          # Creates a helper tag that will help inform the user the use of the field that
          # is being displayed.
          #
          # EXTRA: This uses a directive in popover.js.coffee
          #################################################################################
          makeHelperTag = (entry)->
            htmlInput = "<strong>Attribute:</strong>" + entry.key +
              "</br><strong>Description:</strong>" + entry.description

            newHelpTag = angular.element($document[0].createElement('span'));
            newHelpTag.addClass(attrs.helpClass) if angular.isDefined(attrs.helpClass)
            newHelpTag.attr('popover','')
            newHelpTag.attr('popover-label', '?')
            newHelpTag.attr('popover-placement', 'right')
            newHelpTag.attr('popover-html', htmlInput)

            return newHelpTag;

          #
          # Creates a remove tag that is assigned with an ID number and click-event that
          # will remove the spawned field.
          #################################################################################
          makeRemoveTag = (index) ->
            newRemoveParent = angular.element($document[0].createElement('div'))
            newRemoveParent.addClass(attrs.rmContainerClass) if angular.isDefined(attrs.rmContainerClass)

            newRemoveTag = angular.element($document[0].createElement('span'))
            newRemoveTag.addClass(attrs.removeClass) if angular.isDefined(attrs.removeClass)
            newRemoveTag.attr('ng-click', 'removeField(' + index + ')' )
            newRemoveTag.append('Remove')
            newRemoveParent.append(newRemoveTag)
            return newRemoveParent;

          #
          # Creates the button that a user will click to 'add' a form field
          #################################################################################
          makeAddTag = ()->
            newAddParent = angular.element($document[0].createElement('div'))
            newAddParent.addClass('col-sm-3 control-label')

            newAddTag = angular.element($document[0].createElement('span'))
            newAddTag.addClass('btn btn-success btn-sm active')
            newAddTag.attr('ng-click', 'addField()' )
            newAddTag.append('Add Field')
            newAddParent.append(newAddTag)

            return newAddParent

          #
          # Creates a select feild that will display avaiable attributes stored in the
          # inactive_fields array
          #################################################################################
          makeSelectField = (options, something)->
            newSelectParent = angular.element($document[0].createElement('div'))
            newSelectParent.addClass('col-sm-3')

            newSelect = angular.element($document[0].createElement('select'))
            newSelect.addClass('form-control')
            newSelect.attr('ng-model', 'selectedField')
            newSelect.attr('ng-options', 'option.title for option in inactive_fields track by option.key')
            newSelect.append("<option value=''> Please Choose </option>")
            newSelectParent.append(newSelect)

            return newSelectParent

          #
          # Rebuilds the list that displays avaible fields
          #################################################################################
          makeInactiveList = (inactiveEntries)->
            newSelectContainer = angular.element($document[0].createElement('div'))
            newSelectContainer.addClass('form-group')

            newSelectContainer.append(makeAddTag())
            newSelectContainer.append(makeSelectField(inactiveEntries, false))

            return newSelectContainer;


          #
          # Creates the form's ID tag that will be returned to the server for evlauation
          # Output Examples:
          #  If pre-existing value exists: returns (MODELNAME)['gidNumber']['123']
          #  If no value exists: (MODELNAME)['new']['gidNumber']
          #################################################################################
          makeModel = (scope_model, fieldId, val)->
            if angular.isDefined(val)
              return (scope_model + "['" + fieldId + "']" + "['" + val + "']")
            else
              return (scope_model + "['new']['" + fieldId + "']" )


          #
          # Builds each field, depending on their speicification.
          # This is typically used in a for loop, itterating multible elements
          #################################################################################
          formBuilder = (entry, id) ->
            groupElement = angular.element($document[0].createElement('div'));
            groupElement.addClass('form-group')
            if(angular.isDefined(field_support[entry.type]))
              entry.model = id
              groupElement.append(makeLabel(entry))

              newElement = angular.element($document[0].createElement(field_support[entry.type].element))
              newElement.addClass(field_support[entry.type].fieldClass)
              newElement.attr('type', field_support[entry.type].type)
              newElement.attr('ng-model', makeModel(attrs.ngModel, entry.key, entry.val))

              if(entry.type == 'text' || entry.type == 'password' || entry.type == 'number')
                if angular.isDefined(entry.val)
                  setProperty(model, entry.key, entry.val, true)
                else if entry.required
                  setProperty(model, entry.key, '', false)
                else
                  setProperty(model, entry.key, undefined, false)

              groupElement.append(makeFieldContainer(newElement, entry))
              groupElement.append(makeHelperTag(entry))
              groupElement.append(makeRemoveTag(id))

              return groupElement;

          #
          # Checks the entry to see if entry is ethier required or has a value that exists
          #################################################################################
          isVisableField = (entry)->
            if(entry.required == false && !angular.isDefined(entry.val))
              return false;

            #Check to see if object class is even needed to be displayed
            if(entry.key == 'objectClass' && !angular.isDefined(entry.val))
              objFilter = $filter('filter')(template, {key: 'objectClass'})
              for i in [0 ... objFilter.length-1] by 1
                return false if angular.isDefined(objFilter[i].val)

            return true;

          #
          # Adds entries to the list of display elements
          #################################################################################
          showFields = (entry, id, htmlElement)->
            entry.htmlElement = htmlElement

            $scope.active_fields[id] = entry


          #
          # Adds an entrie to the list of non-display elements
          #################################################################################
          hideFields = (entry, id, htmlElement)->
            entry.htmlElement = htmlElement
            $scope.inactive_fields[id] = entry

          #
          # Rebuilds the form based on the current list of entries
          #################################################################################
          rebuildForm = (activeEntries, inactiveEntries)->
            element.empty()               #Clear contents of the form

            newBody = angular.element($document[0].createElement('div'))

            angular.forEach(activeEntries, (entry)->
              newBody.append(entry.htmlElement)
            )

            newBody.append(makeInactiveList(inactiveEntries))

            $compile(newBody)($scope)    #Compile new HTML build
            element.append(newBody)      #Append to the form body

            return true;

          #
          # Switches a form field between two lists. Then removes the data from the model.
          #################################################################################
          swapFields = (target,destination, index)->
            destination[index] = target[index]

            if angular.isDefined(model[target[index].key])
              model[target[index].key][target[index].val] = ''

            if(angular.isDefined(model['new']) && angular.isDefined(model['new'][target[index].key]))
              model['new'][target[index].key] = ''
              delete model['new'][target[index].key] unless target[index].required

            delete target[index]

          #
          # Action: Click event
          #
          # Removes a field from the displayed form, then adds it to the inactive list
          #################################################################################
          $scope.removeField = (index)->

            if (angular.isDefined($scope.active_fields[index]) &&
                !angular.isDefined($scope.inactive_fields[index]))

              swapFields($scope.active_fields, $scope.inactive_fields, index)
              rebuildForm($scope.active_fields, $scope.inactive_fields)


          #
          # Action: Click event
          #
          # Adds a field from the inactive list to the display list
          #################################################################################
          $scope.addField = ()->

            index = $scope.selectedField.model
            if (!angular.isDefined($scope.active_fields[index]) &&
                 angular.isDefined($scope.inactive_fields[index]))

              swapFields($scope.inactive_fields, $scope.active_fields, index)
              rebuildForm($scope.active_fields, $scope.inactive_fields)

          #
          # (Start) ->
          # Each array elemnt stored in (template) is looped through and will
          # create nessary fields. Then will store each field in its respective container.
          #################################################################################
          #angular.forEach(template, formBuilder, element)

          for i in [0 ... template.length] by 1
            htmlElement = formBuilder(template[i], i)
            if isVisableField(template[i])
              showFields(template[i], i, htmlElement)
            else
              hideFields(template[i],i,htmlElement)

          rebuildForm($scope.active_fields, $scope.inactive_fields)
  }
]