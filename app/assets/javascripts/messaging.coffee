jQuery(document).ready ($) ->

  $(window).on 'resize', -> updateMessageHeaderHeight()

  # mailbox checkbox select (for visual enhancement)
  $('#mailbox .meta input[type="checkbox"]')
    .bind 'click change', ->
      if $(@).filter(':checked').length
        $(@).closest('dd').addClass 'selected'
      else
        $(@).closest('dd').removeClass 'selected'

  # message AJAX load
  $('#mailbox')
    .on 'ajax:before', 'dd a[data-remote]', ->
      $('#message').addClass 'busy'
    .on 'ajax:complete', 'dd a[data-remote]', ->
      $('#message').removeClass 'busy'
    .on 'ajax:error', 'dd a[data-remote]', (xhr, status, error) ->
      $.alert body: 'Unable to load message.'
    .on 'ajax:success', 'dd a[data-remote]', (event, data, status, xhr) ->
      $('#mailbox dd').removeClass 'open'
      dd = $(@).closest('dd')
      if dd.hasClass 'read'
        dd.addClass 'open'
      else
        envelope = $('#bar .envelope a')
        num = envelope.attr('meta') - 1
        if num
          envelope.attr('meta', num)
        else
          envelope.removeAttr 'meta'
        dd.addClass 'read open'
      $('#message').html xhr.responseText
      if typeof(history.replaceState) is typeof(Function)
        history.replaceState {}, $('#message h1').text(), $('#message header').attr 'slug'

  # user profile suggestion and selection for the "to" field
  $('#message.compose').each ->
    cache = []

    $('#message_to').autocomplete
      autoFocus: true
      create: (e, ui) ->
        $('ul.ui-autocomplete li:has(img)').addClass 'with-avatar'
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
        $('<ul>').appendTo '.to_list' unless $('.to_list ul').length
        $('.to_list ul').append """
          <li>
            <a target='_blank' href='#{ui.item.url}'>
              #{ui.item.label}
              <span class='close'></span>
            </a>
            <input type='hidden' name='message[to][]' value='#{ui.item.value}'>
          </li>
        """
        $(@).val ''
        updateMessageHeaderHeight()
        removeToListDuplicates()
        return false
      source: (request, response) ->
        term = request.term
        return response cache[term] if cache[term]?
        lastXhr = $.getJSON $('#message_to').data('url'), request, (data, status, xhr) ->
          cache[term] = data
          response data if xhr is lastXhr

    $('#message_to').data('autocomplete')._renderItem = (ul, item) ->
      li = $('<li>').data('item.autocomplete', item).appendTo ul
      html = '<a>'
      if item.avatar?
        li.addClass 'with-avatar'
        html += "<img src='#{item.avatar}' alt=''>"
      html += "#{item.label}</a>"
      li.html html
      return li

    $('.to_list').on 'click', '.close', ->
      $(@).closest('li').remove()
      updateMessageHeaderHeight()
      return false

    $('#message_subject, #message_body').on 'focus keypress', ->
      updateMessageListClasses()
      $('aside ul, aside label').hide()

    $('mark').click ->
      $(@).animate opacity: 0, 200, 'linear'

    updateMessageHeaderHeight()

  # auto-focus the correct field
  if $('input[name="message[to][]"]').length > 0
    $('#message_body').focus()
  else
    $('#message_to').focus()

  # Toggle check/uncheck box for messages
  $('#mailbox-menu .actions')
    .after('<dd class="toggle"><button type="button" meta="Check/uncheck all messages">Check/uncheck all messages</button></dd>')
    .closest('dl')
    .find('.toggle button')
    .data('checked',false)
    .click ->
      $(@).data('checked',!$(@).data('checked'))
      $('#mailbox dd .meta input').attr('checked',$(@).data('checked'))

updateMessageHeaderHeight = ->
  $('#message.compose article').css({ top: $('header').height() + 35 })

updateMessageListClasses = ->
  $('aside li').removeClass 'first last'
  visible = $('aside li:has(label:visible)')
  visible.filter(':first').addClass 'first'
  visible.filter(':last').addClass 'last'

removeToListDuplicates = ->
  seen = {}
  $($('.to_list li').get().reverse()).each ->
    txt = $(@).text()
    $(@).remove() if seen[txt]
    seen[txt] = true