$(".ldap_users.edit").ready ->
  excludeList = new Array()

  $(this).on 'click', 'form .add_fields', (e) ->
    e.preventDefault()
    requrl = $(this).data('url')
    oureq  = $(this).data('ou')

    if excludeList.length <= 0
      data = $.ajax(
        url: requrl
        type: "GET"
        dataType: "json"
        async: false
        error: () ->
          console.log("Could not get exclude list!");
      ).responseText
      excludeList = jQuery.parseJSON(data)


    data = jQuery.parseJSON($.ajax(
      url: "/requests"
      type: "GET"
      dataType: 'json'
      async: false
      data:
        request_data: JSON.stringify(
          type:'attribute_request'
          name: oureq
          exclude: excludeList)
      error: () ->
        console.log(excludeList.toString())
        console.log("Could not get REQUEST DATA! AJAX ERROR!");
    ).responseText)

    #Inserts a html drop down menu with avaiable attributes that the server gave back
    form_field = "<div class = 'form-group'>"
    form_field += '<select name="new_trigger" class="col-sm-2 control-label" id="attribute-select">'
    form_field += '<option selected disabled>-Select Attribute-</option>'
    jQuery.each data, ->
      form_field +=  '<option value="' + this['keyattribute'] + '">' + this['keyattribute'] + '</option>';

    form_field += '</select>'
    form_field += '<div class=\"col-sm-10\" id="field-area">SELECT OPTION</div>'
    form_field += '<a href="#" class="remove_fields">Remove</a></div>'

    $(this).prev('fieldset').append(form_field)
    console.log(data)

  $(this).on 'change', '#attribute-select', (e) ->
    e.preventDefault()
    console.log($(this).val())

    #prevent this attribute from being selected again
    excludeList.push($(this).val())

    form_field = '<div class=\"col-sm-10\" id="field-area">'
    form_field += '<input class="form-control" type="text" name="user_data[new][' + $(this).val() + ']"><br>'
    form_field += '</div>'
    $(this).next('div').replaceWith(form_field)


  $(this).on 'click', 'form .remove_fields', (e) ->
      e.preventDefault()
      removeItem = $(this).parent().find('#attribute-select').val()
      excludeList.splice($.inArray(removeItem, excludeList), 1) if removeItem != null && removeItem.length > 0
      $(this).parent('div').remove()

