jQuery(document).ready ($) ->

  cache = []
  users = []
  emails = []

  $('#recruit_input')

    .keypress (e) ->
      key = e.keyCode ? e.which
      return unless key is 13
      recruit = $.trim($(@).val()).toLowerCase()
      return if recruit is ''
      return $.alert body: 'Invalid email address.' unless recruit.match /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}/i
      $(@).val ''
      return if recruit in emails
      emails.push recruit
      elId = "email_#{(new Date()).getTime()}"
      li = $('<li>').prependTo '#recruits fieldset ol'
      $("<input id='#{elId}' name='emails[]' type='checkbox' value='#{recruit}' checked='checked'>").appendTo(li).attr
      label = $("<label for='#{elId}'>").appendTo(li).text recruit
      $('<img>').prependTo(label).attr src: $(@).data 'avatar'
      $('#recruits .submit button').removeClass('disabled').removeAttr('disabled') if $('#recruits li').length

    .autocomplete
      autoFocus: true
      create: (e, ui) ->
        $('ul.ui-autocomplete').addClass 'with-avatars'
      delay: 300
      focus: (e, ui) ->
        $(@).val ui.item.label
        return false
      minLength: 2
      open: (e, ui) ->
        $(@).autocomplete('widget').width $(@).width() + 8
      position:
        my: 'left top'
        at: 'left bottom'
        offset: '0, -3'
        collision: 'none'
      select: (e, ui) ->
        unless ui.item.value in users
          users.push ui.item.value
          console.log ui.item
          elId = "user_#{(new Date()).getTime()}"
          li = $('<li>').prependTo '#recruits fieldset ol'
          $("<input id='#{elId}' name='users[]' type='checkbox' value='#{ui.item.value}' checked='checked'>").appendTo(li).attr
          label = $("<label for='#{elId}'>").appendTo(li).text ui.item.label
          $('<img>').prependTo(label).attr src: ui.item.avatar
          $('#recruits .submit button').removeClass('disabled').removeAttr('disabled') if $('#recruits li').length
        $(@).val ''
        return false
      source: (request, response) ->
        return if $('#recruit_input').val().match /@/
        term = request.term
        return response cache[term] if cache[term]?
        lastXhr = $.getJSON $('#recruit_input').data('url'), request, (data, status, xhr) ->
          cache[term] = data
          response data if xhr is lastXhr
          results = $.parseJSON xhr.responseText

  $('#recruits').on 'change', 'input[type="checkbox"]', ->
    return if $(@).filter(':checked').length
    val = $(@).val()
    switch $(@).attr('name').replace(/[^a-z]/gi,'')
      when 'emails' then emails.splice emails.indexOf(val), 1
      when 'users' then users.splice users.indexOf(val), 1
    $('#recruits .submit button').addClass('disabled').attr('disabled',true) if $('#recruits li').length <= 1
    $(@).closest('li').remove()