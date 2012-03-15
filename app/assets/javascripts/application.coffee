//= require jquery
//= require jquery_ujs

((jQuery) ->

  # alert box
  $.alert = (options) ->
    title = options['title'] or= ''
    body = options['body'] or= ''
    button = options['button'] or= 'Ok'
    action = options['action']
    $('body').append('<div id="mask"></div><div id="modal" class="alert"><div class="actions"><button>' + button + '</button></div></div>')
    $('#modal').prepend('<p>' + body + '</p>') if body
    $('#modal').prepend('<h1>' + title + '</h1>') if title
    $('#mask').remove() if $('.wmd-prompt-background').length
    $('#mask, .wmd-prompt-background')
      .css({ opacity: 0 })
      .animate({ opacity: .7 }, 400, 'linear')
    $('#modal')
      .css({ opacity: 0, marginLeft: -500 })
      .animate({ opacity: 1, marginLeft: -250 }, 200)
    $('#modal button').click action if action
    $('#modal button').click ->
      $('#modal, .wmd-prompt-dialog').animate { marginTop: 0, opacity: 0 }, 300
      $('#mask, .wmd-prompt-background').animate { opacity: 0 }, 600, ->
        $('#mask, .wmd-prompt-background, #modal').remove()
        
  # confirm box
  $.confirm = (options) ->
    title = options['title'] or= ''
    body = options['body'] or= ''
    cancel = options['cancel'] or= 'Cancel'
    affirm = options['affirm'] or= 'Continue'
    action = options['action']
    dismiss = ->
      $('#modal, .wmd-prompt-dialog').animate { marginTop: 0, opacity: 0 }, 300
      $('#mask, .wmd-prompt-background').animate { opacity: 0 }, 600, ->
        $('#mask, .wmd-prompt-background, #modal').remove()
    $('body').append('<div id="mask"></div><div id="modal" class="confirm"><h1>' + title + '</h1><p>' + body + '</p><div class="actions"><button class="cancel">' + cancel + '</button><button class="affirm">' + affirm + '</button></div></div>')
    $('#mask').remove() if $('.wmd-prompt-background').length
    $('#mask, .wmd-prompt-background')
      .css({ opacity: 0 })
      .animate({ opacity: .7 }, 400, 'linear')
      .click ->
        $('#modal, .wmd-prompt-dialog').find('.cancel').trigger 'click'
    $('#modal')
      .css({ opacity: 0, marginLeft: -500 })
      .animate({ opacity: 1, marginLeft: -250 }, 200)
    $('#modal button.cancel').click dismiss
    $('#modal button.affirm').click ->
      action()
      dismiss()
        
  # prompt input box
  $.prompt = (options) ->
    require = options['require'] or= false
    title = options['title'] or= ''
    body = options['body'] or= ''
    cancel = options['cancel'] or= 'Cancel'
    affirm = options['affirm'] or= 'Submit'
    action = options['action']
    dismiss = ->
      $('#modal, .wmd-prompt-dialog').animate { marginTop: 0, opacity: 0 }, 300
      $('#mask, .wmd-prompt-background').animate { opacity: 0 }, 600, ->
        $('#mask, .wmd-prompt-background, #modal').remove()
    $('body').append('<div id="mask"></div><div id="modal" class="prompt"><h1>' + title + '</h1><p>' + body + '</p><p><input type="text" id="prompt" /></p><div class="actions">' + (if !require then '<button class="cancel">' + cancel + '</button>' else '') + '<button class="affirm">' + affirm + '</button></div></div>')
    $('#mask').remove() if $('.wmd-prompt-background').length
    $('#mask, .wmd-prompt-background')
      .css({ opacity: 0 })
      .animate({ opacity: .7 }, 400, 'linear')
      .click ->
        $('#modal, .wmd-prompt-dialog').find('.cancel').trigger 'click'
    $('#modal')
      .css({ opacity: 0, marginLeft: -500 })
      .animate({ opacity: 1, marginLeft: -250 }, 200)
    $('#prompt').focus ->
      $(this).select()
    $('#modal button.cancel').click dismiss if !require
    $('#modal button.affirm').click ->
      action($('#modal #prompt').val())
      dismiss()
        
) jQuery

$(document).ready ->
  
  # dynamic loaded content after page load
  $('body')
    .delegate '.dynload', 'ajax:error', (xhr, status, error) ->
      errormsg = $(this).attr 'data-error'
      $.alert { body: errormsg } if errormsg
    .delegate '.dynload', 'ajax:success', (event, data, status, xhr) ->
      $($(this).attr('data-target')).html xhr.responseText
  $('.dynload:not(.wait)').trigger 'click'
  
  # replace derp avatars with default
  $('.avatar img, img.avatar').bind 'error', ->
    if $(this).css('width')
      width = $(this).css('width').replace /[^\d]/g, ''
    else
      width = $(this).closest('.avatar').width()
    src = $(this).attr('src')
    avatar = '/assets/application/avatar@'+width+'.png'
    $(this)
      .attr('src', avatar)
      .unbind 'error'
  
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
  
  # batch actions
  $('form .batch button, form button.batch')
    .click ->    
      $(this)
        .closest('form')
        .prop({ action: $(this).attr('action') })
        .find('input[name="_method"]')
        .val $(this).attr('method')
  
  # select box auto-hide and scroll-back actions
  $('body').delegate '.select', 'mouseenter mouseleave', ->
    $(this).scrollTop(0)
    $(this).find('ul').scrollTop(0)
  $('.select, .select ul').scroll ->
    $(this).scrollLeft(0)
  $('body').delegate '.select ul label, form .profile label', 'click', ->
    select = $(this).closest('.select')
    ul = $(this).closest('ul')
    ul.animate { opacity: 0 }, 200, ->
      ul
        .hide()
        .animate { opacity: 0 }, 5, ->
          ul.show().css { opacity: 1 }
    setTimeout ->
      select.scrollTop(0)
      ul.scrollTop(0)
    , 250
  
  # flash messages
  adjustHeaderByFlash = (speed,rowOffset=0) ->
    if $('body.fluid').length || $('#flash').length
      messageCount = $('#flash li').length or= 0
      amount = (messageCount + rowOffset) * 40
      $('#header')
        .animate({ paddingTop: amount }, speed)
      $('body:not(.top_level) #body')
        .animate({ marginTop: amount }, speed)
      if $('.sidemenu').length
        $('.sidemenu, .editor, #wmd-fields, #wmd-preview, #mailbox, #message, #message header .actions')
          .animate({ top: (amount + 70) + 'px' }, speed)

  $('body')
    .delegate '#flash li', 'init', ->
      $(this).append('<a class="dismiss">✕</a>') unless $(this).find('.read').length
      $(this)
        .css({ height: 0, lineHeight: 0 })
        .animate({ height: 40 + 'px', lineHeight: 40 + 'px' }, 600)
      
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
              if xhr.responseText
                $('#flash').prepend xhr.responseText
                $('#flash li:first').trigger 'init'
              setTimeout adjustHeaderByFlash, 50
              $(this).remove()
  $('#flash li').trigger 'init'
  
  # tiered form field selection
  $('form .select[affects] input')
    .change ->
      select = $(this).closest('.select')
      li = select.closest('li')
      affects_collection = select.attr('affects')
      form = select.closest('form')
      for affects in affects_collection.split(/\s/) when affects
        affected = form.find('.affected.'+affects)
        val = select.find('input:checked').val()
        if li.filter('[affected_by]').length
          val = form.find('.select.'+li.attr('affected_by')+' input:checked').val() + '_' + val
        val = if val? then val.replace /\s/gi, '_' else ''
        options = affected.find('.options[class_name="'+val+'"]')
        affected
          .hide()
          .find('.options')
          .hide()
          .find('input')
          .prop('disabled', true)
          .prop('readonly', true)
        if options.length
          affected.show()
        options
          .show()
          .find('input')
          .each ->
            $(this)
              .prop('disabled', false)
              .prop('readonly', false)
        if affected.find('.select[affects]:visible').length
          affected.find('.select[affects]:visible input:first').trigger 'change'
  $('form .select[affects] input:checked').trigger 'change'
  
  # tabs
  $('dl.tabs >dt').click ->
    $(this).closest('dl.tabs').find('>dt').removeClass('current')
    $(this).addClass('current')
  if window.location.hash
    $('#tabs .'+window.location.hash.replace('#','')).trigger 'click'
  $('a[href*="#"]').click ->
    link = $(this).attr('href').split('#').pop()
    tab = $('dl.tabs >dt.'+link)
    if(tab.length)
      tab.trigger 'click'
      return false
  
  # slider input fields
  $('body')
    .delegate '.slider', 'init', ->
      $(this).css('width', $(this).find('label').length * 70)
  $('.slider').trigger 'init'
  
  # inputs that affect the hidden _destroy field
  $('input[toggle_destroy="true"]').change ->
    $(this).prevAll('input[name*="_destroy"]:first').attr('checked', !$(this).prop('checked'))
  
  # fluid sidebar menu
  $('.sidemenu')
    .find('a, button, .wmd-button')
    .filter('[title]')
    .each ->
      $(this)
        .attr('meta',$(this).attr('title'))
        .removeAttr 'title'
            
  adjustHeaderByFlash(600)
  
  # Global checkbox
  $('body')
    .delegate 'thead th.check', 'init', ->
      $(this)
        .append('<a>✔</a>')
        .find('a')
        .data('checked',false)
        .click ->
          $(this).data('checked', !$(this).data('checked'))
          $(this).closest('table').find('tbody td.check input').attr('checked',$(this).data('checked'))
  $('body thead th.check').trigger 'init'