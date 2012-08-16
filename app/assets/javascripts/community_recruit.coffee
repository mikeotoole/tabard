jQuery(document).ready ($) ->

  acCache = []

  $('#recruit_input')

    .keypress (e) ->
      key = e.keyCode ? e.which
      return unless key is 13
      recruit = $.trim($(@).val()).toLowerCase()
      return if recruit is ''
      return $.alert body: 'Invalid email address.' unless recruit.match /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}/i
      $(@).val ''
      $(@).data 'emails', [] unless $(@).data 'emails'
      emails = $(@).data 'emails'
      return if recruit in emails
      emails.push recruit
      elId = "email_#{(new Date()).getTime()}"
      li = $('<li>').prependTo '#recruits fieldset ol'
      $("<input id='#{elId}' name='emails[]' type='checkbox' value='#{recruit}' checked='checked'>").appendTo(li).attr
      $("<label for='#{elId}'>").appendTo(li).text recruit

    .autocomplete
      autoFocus: true
      create: (e, ui) ->
        $('ul.ui-autocomplete').addClass 'with-avatars'
      delay: 500
      minLength: 2
      open: (e, ui) ->
        $(@).autocomplete('widget').width $(@).width() + 8
      position:
        my: 'left top'
        at: 'left bottom'
        offset: '0, -3'
        collision: 'none'
      select: (e, ui) ->
        console.log e, ui
      source: ['apple','application','apart']
      #source: (request, response) ->
      #  term = request.term
      #  return response acCache[term] if acCache[term]?
      #  lastXhr = $.getJSON $('#recruit_input').data('url'), request, (data, status, xhr) ->
      #    acCache[term] = data
      #    response data if xhr is lastXhr

  $('#recruits').on 'change', 'input[type="checkbox"]', ->
    return if $(@).filter(':checked').length
    recruit = $(@).val()
    recruits = $('#recruit_input').data $(@).attr('name').replace(/[^a-z]/gi,'')
    recruits.splice recruits.indexOf(recruit), 1
    $(@).closest('li').remove()