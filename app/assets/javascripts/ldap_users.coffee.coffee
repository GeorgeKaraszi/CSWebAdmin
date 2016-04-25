$(".ldap_users.edit").ready ->
  excludeList = new Array()
  wrapper = $('.form-group')

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
      excludeList.push(data)

    console.log(excludeList)
    $.ajax(
      url: "/requests"
      type: "POST"
      dataType: 'json'
      data:
        request_data:
          type:'attribute_request'
          name: oureq
          excludes: JSON.stringify(excludeList)
      success: (data) ->
        console.log('trying')
        console.log(data)
      error: () ->
        console.log(excludeList.toString())
        console.log("Could not get REQUEST DATA! AJAX ERROR!");
    )