//= require jquery
//= require jquery_ujs

dump = (arr, level) ->
  dumped_text = ""
  level = 0  unless level
  level_padding = ""
  j = 0

  while j < level + 1
    level_padding += "    "
    j++
  if typeof (arr) is "object"
    for item of arr
      value = arr[item]
      if typeof (value) is "object"
        dumped_text += level_padding + "'" + item + "' ...\n"
        dumped_text += dump(value, level + 1)
      else
        dumped_text += level_padding + "'" + item + "' => \"" + value + "\"\n"
  else
    dumped_text = "===>" + arr + "<===(" + typeof (arr) + ")"
  dumped_text

(($) ->

  # alert box
  $.alert = (options) ->
    title = options['title'] or= ''
    body = options['body'] or= ''
    button = options['button'] or= 'Ok'
    action = options['action']
    $('body').append('<div id="mask"></div><div id="modal" class="alert"><div class="actions"><button>' + button + '</button></div></div>')
    $('#modal').prepend('<p>' + body + '</p>') if body
    $('#modal').prepend('<h1>' + title + '</h1>') if title
    $('#mask')
      .css({ opacity: 0 })
      .animate({ opacity: .7 }, 400, 'linear')
    $('#modal')
      .css({ opacity: 0, marginLeft: -500 })
      .animate({ opacity: 1, marginLeft: -250 }, 200)
    $('#modal button').click action if action
    $('#modal button').click ->
      $('#modal').animate { marginTop: 0, opacity: 0 }, 300
      $('#mask').animate { opacity: 0 }, 600, ->
        $('#mask, #modal').remove()
        
  # confirm box
  $.confirm = (options) ->
    title = options['title'] or= ''
    body = options['body'] or= ''
    cancel = options['cancel'] or= 'Cancel'
    affirm = options['affirm'] or= 'Continue'
    action = options['action']
    $('body').append('<div id="mask"></div><div id="modal" class="confirm"><h1>' + title + '</h1><p>' + body + '</p><div class="actions"><button class="cancel">' + cancel + '</button><button class="affirm">' + affirm + '</button></div></div>')
    $('#mask')
      .css({ opacity: 0 })
      .animate({ opacity: .7 }, 400, 'linear')
    $('#modal')
      .css({ opacity: 0, marginLeft: -500 })
      .animate({ opacity: 1, marginLeft: -250 }, 200)
    $('#modal button.cancel').click ->
      $('#modal').animate { marginTop: 0, opacity: 0 }, 300
      $('#mask').animate { opacity: 0 }, 600, ->
        $('#mask, #modal').remove()
      
    $('#modal button.affirm').click action if action
    $('#modal button.affirm').click ->
      $('#modal button.cancel').trigger 'click'
        
) jQuery

$(document).ready ->
  
  # text box suggest
  $('form input').each ->
    $(this).data 'default', $(this).attr 'title'
    $(this).removeAttr 'title'
    $(this).focus ->
      if $.trim($(this).attr 'value') is $(this).data('default')
        $(this).val ''
    $(this).blur ->
      if $.trim($(this).attr 'value') is ''
        $(this).val $(this).data 'default'
    $(this).trigger 'blur'
  
  # override rails allow action (for data-confirm)
  $.rails.allowAction = (element) ->
    message = element.data("confirm")
    return true unless message
    if element.data('affirm') == yes
      if $.rails.fire(element, "confirm")
        $.rails.fire(element, "confirm:complete", [ true ])
    else
      $.confirm
        body: element.data 'confirm'
        action: ->
          element.data 'affirm', yes
          element.click()
          $('#modal button.cancel').trigger 'click'
      false
  
  # Flash messages
  adjustHeaderByFlash = (speed,rowOffset=0) ->
    if $('body.fluid').length || $('#flash').css('position') != 'relative'
      messageCount = $('#flash li').length or= 0
      amount = (messageCount + rowOffset) * 40
      $('#header')
        .animate({ paddingTop: amount }, speed)
      $('#body')
        .animate({ marginTop: amount }, speed)
      if $('#mailbox').length
        $('#mailbox, #mailbox-menu, #message, #message header .actions')
          .animate({ top: (amount + 70) + 'px' }, speed)

  $('#flash li')
    .live 'load', ->
          
      $(this).append('<a class="dismiss">✕</a>') unless $(this).find('.read').length
      $(this)
        .css({ height: 0, lineHeight: 0 })
        .animate({ height: 40, lineHeight: 40 + 'px' }, 600)
      
      $(this).find('.dismiss')
        .click ->
          adjustHeaderByFlash(300,-1)
          $(this)
            .closest('li')
            .animate { height: 0, lineHeight: 0 + 'px' }, 300, ->
              $(this).remove()
              
      $(this).find('.read')
      
        .bind 'ajax:beforeSend', ->
          $(this).closest('li').addClass('busy')
          
        .bind 'ajax:error', (xhr, status, error) ->
          row = $(this).closest('li')
          $.alert
            body: error
            action: ->
              row.removeClass('busy')
              
        .bind 'ajax:success', (event, data, status, xhr) ->
          if data.result == true
            $('#bar .notice a').each ->
              num = $(this).attr('meta') - 1
              if num > 0
                $(this).attr 'meta', num
              else
                $(this).removeAttr 'meta'
            adjustHeaderByFlash(300,-1)
            $(this)
              .closest('li')
              .animate { height: 0, lineHeight: 0 + 'px' }, 300, ->
                if data.announcement
                  $('#flash').prepend data.announcement
                  $('#flash li:first').trigger 'load'
                setTimeout adjustHeaderByFlash, 50
                $(this).remove()
          else
            $(this).closest('li').removeClass('busy')
            
    .trigger 'load'
            
  adjustHeaderByFlash(600)