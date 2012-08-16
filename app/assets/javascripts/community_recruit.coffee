jQuery(document).ready ($) ->

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
      return if emails.indexOf(recruit) > -1
      emails.push recruit
      elId = "email_#{(new Date()).getTime()}"
      li = $('<li>').prependTo '#recruits fieldset ol'
      $("<input id='#{elId}' name='emails[]' type='checkbox' value='#{recruit}' checked='checked'>").appendTo(li).attr
      $("<label for='#{elId}'>").appendTo(li).text recruit

    .autocomplete
      autoFocus: true
      delay: 300
      minLength: 2
      open: ->
        $(@).addClass('with-avatars').autocomplete('widget').width $(@).width() + 8
      position:
        my: 'left top'
        at: 'left bottom'
        offset: '0, -3'
        collision: 'none'
      source:
        [
          'accredit'
          'ace'
          'Acer'
          'acetone'
          'achoo'
          'acorn'
          'acre'
          'action'
          'actor'
          'actress'
          'zoink'
          'zoo'
          'zorg'
        ]
      select: (e, ui) ->
        console.log e, ui
        

  $('#recruits').on 'change', 'input[type="checkbox"]', ->
    return if $(@).filter(':checked').length
    recruit = $(@).val()
    recruits = $('#recruit_input').data $(@).attr('name').replace(/[^a-z]/gi,'')
    recruits.splice recruits.indexOf(recruit), 1
    $(@).closest('li').remove()