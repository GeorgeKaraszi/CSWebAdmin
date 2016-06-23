@app = angular.module('formBuilder', ['ngResource', 'ngTagsInput'])

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
        $scope.objectFields = []

        if(!angular.isDefined(attrs.ngModel) || !angular.isDefined(attrs.templateUrl) || !angular.isDefined(attrs.objectUrl))
          console.log('Error: Require ng-model, template-url and object-url properties')
          return false

        templateUrl = $parse(attrs.templateUrl)($scope)
        objectUrl = $parse(attrs.objectUrl)($scope)
        model = $parse(attrs.ngModel)($scope)


        ($http.get(templateUrl, {cache: $templateCache}).then (results)->
            return results.data
        ).then (template)->

          #
          # Creates and assigns values to a given model. These are nessary for outside
          # controllers that will handel data, to be initalized before a DOM $compile is
          # issued. Otherwise spawned field models will not update.
          #################################################################################
          setProperty = (obj, key, value)->
              obj[key] = value

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
          # Creates object class taps that are displayed on the form
          #################################################################################
          makeObjectTags = (entry)->

            $scope.objectFields = entry.val.split(',')

            newObjectTag = angular.element($document[0].createElement('tags-input'))
            newObjectTag.attr('ng-model', 'objectFields')
            newObjectTag.attr('paste-split-pattern', "[,]")
            newObjectTag.attr('add-on-comma', 'true')
            newObjectTag.attr('on-tag-added', "addObjectClass($tag)")
            newObjectTag.attr('on-tag-removed', "removeObjectClass($tag)")

#            $compile(newObjectTag)($scope)    #Compile new HTML build

#            autocomplete = angular.element($document[0].createElement('auto-complete'))
#            autocomplete.attr('source',  'some function with tags that will be accesptable')
#            newObjectTag.append(autocomplete)

            return newObjectTag

          #
          # Creates a remove tag that is assigned with an ID number and click-event that
          # will remove the spawned field.
          #################################################################################
          makeRemoveTag = (index) ->
            newRemoveParent = angular.element($document[0].createElement('div'))
            newRemoveParent.addClass(attrs.actionContainerClass) if angular.isDefined(attrs.actionContainerClass)

            newRemoveTag = angular.element($document[0].createElement('span'))
            newRemoveTag.addClass(attrs.removeClass) if angular.isDefined(attrs.removeClass)
            newRemoveTag.attr('ng-click', 'removeField(' + index + ')' )
            newRemoveTag.append('Remove')
            newRemoveParent.append(newRemoveTag)
            return newRemoveParent;

          #
          # Creates a tag to inform the user that the field is required to be completed
          #################################################################################
          makeRequiredTag = (index) ->
            newRequiredParent = angular.element($document[0].createElement('div'))
            newRequiredParent.addClass(attrs.actionContainerClass) if angular.isDefined(attrs.actionContainerClass)

            newRequiredTag = angular.element($document[0].createElement('span'))
            newRequiredTag.addClass(attrs.requiredClass) if angular.isDefined(attrs.requiredClass)
            newRequiredTag.append('Required')
            newRequiredParent.append(newRequiredTag)
            return newRequiredParent;

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
          makeSelectField = (options)->
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
            console.log(inactiveEntries)
            console.log($scope.selectedField)
            newSelectContainer = angular.element($document[0].createElement('div'))
            newSelectContainer.addClass('form-group')

            newSelectContainer.append(makeAddTag())
            newSelectContainer.append(makeSelectField(inactiveEntries))

            return newSelectContainer;


          #
          # Creates the form's ID tag that will be returned to the server for evlauation
          # Output Examples:
          #  If pre-existing value exists: returns (MODELNAME)['gidNumber']
          #################################################################################
          makeModel = (scope_model, fieldId)->
              return (scope_model + "['" + fieldId + "']")


          #
          # Core: Builds the HTML representation of each form field
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

              #Set value to model that will send data back to the server
              if(entry.type == 'text' || entry.type == 'password' || entry.type == 'number')
                if angular.isDefined(entry.val)
                  setProperty(model, entry.key, entry.val)
                else if entry.required
                  setProperty(model, entry.key, '')
                else
                  setProperty(model, entry.key, undefined)

              #Create HTML elements to display on the page
              if entry.key is 'objectClass'
                newElement = makeObjectTags(entry)
              else
                newElement = angular.element($document[0].createElement(field_support[entry.type].element))
                newElement.addClass(field_support[entry.type].fieldClass)
                newElement.attr('type', field_support[entry.type].type)
                newElement.attr('ng-model', makeModel(attrs.ngModel, entry.key))
              groupElement.append(makeFieldContainer(newElement, entry))
              groupElement.append(makeHelperTag(entry))

              if entry.required
                groupElement.append(makeRequiredTag(id))
              else
                groupElement.append(makeRemoveTag(id))

              return groupElement;

          #
          # Checks the entry to see if entry is ethier required or has a value that exists
          #################################################################################
          isVisableField = (entry)->
            if angular.isDefined(entry.val)
              return true
            if angular.isDefined(entry.required)
              return entry.required

            return false

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
                model[target[index].key] = ''

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
          # Action: Click event
          #
          # Remove's an object class to the form and calls the request API to gather
          # require information. Then rebuilds the form with the new required attributes
          #################################################################################
          $scope.removeObjectClass = (key)->
            unless model['objectClass'].length is 0
              objectModel = model['objectClass'].split(',')
              indexModel = objectModel.indexOf(key.text)
              objectModel.splice(indexModel, 1)
              model['objectClass'] = objectModel.join()
              $scope.updateObjectDisplay()

          #
          # Action: Click event
          #
          # Add's an object class to the form and calls the request API to gather
          # require information. Then rebuilds the form with the new required attributes
          #################################################################################
          $scope.addObjectClass = (key)->
            unless key is `undefined`
              objectClasses = model['objectClass'].split(',')
              objectClasses.push(key.text)
              model['objectClass'] = objectClasses.join(',')
              $scope.updateObjectDisplay()


          #
          # Updates the display of required attriutes after a change in object classes occur
          #################################################################################
          $scope.updateObjectDisplay = ()->
            url = (objectUrl + model['objectClass'])



            $http.get(url).then(
              (successData)->
                data = successData.data
                field_list = []

                angular.extend(field_list, $scope.active_fields, $scope.inactive_fields)
                for y in [0 ... $scope.active_fields.length] by 1
                  delete $scope.active_fields[y]

                for j in [0 ... $scope.inactive_fields.length] by 1
                  delete $scope.inactive_fields[j]

                for i in [0 ... field_list.length] by 1
                  required_object = undefined
                  angular.forEach(data, (entry)->
                    required_object = entry if field_list[i].key == entry.key
                  )

                  if angular.isDefined(required_object) is true
                    data.splice(required_object, 1)
                    field_list[i] = required_object
                  else
                    field_list[i].required = false


                angular.extend(field_list, field_list, data) unless data.length is 0

                for x in [0 ... field_list.length] by 1
                  htmlElement = formBuilder(field_list[x], x)
                  if isVisableField(field_list[x])
                    showFields(field_list[x], x, htmlElement)
                  else
                    hideFields(field_list[x],x, htmlElement)

                rebuildForm($scope.active_fields, $scope.inactive_fields)
            )


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