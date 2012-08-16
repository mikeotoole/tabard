jQuery(document).ready ($) ->

  $('#recruit_input')

    .keypress (e) ->
      key = e.keyCode ? e.which
      return unless key is 13
      recruit = $.trim($(@).val()).toLowerCase()
      $(@).val ''
      return if recruit is ''
      $(@).data 'recruits', [] unless $(@).data 'recruits'
      recruits = $(@).data 'recruits'
      return if recruits.indexOf(recruit) > -1
      recruits.push recruit
      $('<ol>').prependTo '#new_community_invite fieldset' unless $('#new_community_invite fieldset ol').length
      li = $('<li>').prependTo '#new_community_invite fieldset ol'
      rId = "recruit_#{(new Date()).getTime()}"
      $("<input id='#{rId}' name='recruits[]' type='checkbox' value='#{recruit}' checked='checked'>").appendTo(li).attr
      $("<label for='#{rId}'>").appendTo(li).text recruit

    .autocomplete
      autoFocus: true
      delay: 300
      minLength: 2
      open: ->
        $(@).autocomplete('widget').width $(@).width() + 8
      position:
        my: 'left top'
        at: 'left bottom'
        offset: '0, -3'
        collision: 'none'
      source: [
        'acai'
        'accredit'
        'ace'
        'acorn'
        'action'
        'actor'
        'actress'
        'zoo'
      ]

  $('#new_community_invite').on 'change', 'input[type="checkbox"]', ->
    return if $(@).filter(':checked').length
    recruit = $(@).val()
    recruits = $('#recruit_input').data 'recruits'
    recruits.splice recruits.indexOf(recruit), 1
    $(@).closest('li').remove()