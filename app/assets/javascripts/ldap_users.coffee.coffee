$(".ldap_users.edit").ready ->
  excludeList = new Array()
  wrapper = '.form-group'

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


    $.ajax(
      url: "/requests"
      type: "POST"
      dataType: 'json'
      data:
        request_data: JSON.stringify(
          type:'attribute_request'
          name: oureq
          exclude: excludeList)
      success: (data) ->
        console.log('trying');
        #console.log($(this).closest(wrapper))
        #$(this).closest(wrapper).append('<div><input type="text" name="mytext[]"/><a href="#" class="remove_field">Remove</a></div>')
      error: () ->
        console.log(excludeList.toString())
        console.log("Could not get REQUEST DATA! AJAX ERROR!");
    ).responseText

    console.log($(this).closest('div'))
    $(this).closest('fieldset').hide()
    $(this).closest('fieldset').append('<div>HELLO!</div>')