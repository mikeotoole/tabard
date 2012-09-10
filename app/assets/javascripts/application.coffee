//= require jquery
//= require jquery_ujs
//= require jquery-ui


# global var access
root = exports ? this


((jQuery) ->

  # alert box
  $.alert = (options) ->
    document.activeElement.blur()
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
    setTimeout ->
      $(document).on 'keypress', ->
        $('#modal button').trigger 'click'
        $(document).off 'keypress'
    , 300
        
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
      $(@).select()
    $('#modal button.cancel').click dismiss if !require
    $('#modal button.affirm').click ->
      action($('#modal #prompt').val())
      dismiss()

  $.flash = (type, html) ->
    $('<ul id="flash">').insertAfter '#bar' unless $('#flash').length
    $('<li>').addClass(type).html(html).appendTo('#flash').trigger 'init'
    adjustHeaderByFlash()

) jQuery


# Adjust page to accomodate flash messages
adjustHeaderByFlash = (speed,rowOffset=0) ->
  if $('body').hasClass('fluid') and $('#flash').length
    messageCount = $('#flash li').length ? 0
    amount = (messageCount + rowOffset) * 40
    $('#header')
      .animate({ paddingTop: amount }, speed)
    $('body:not(.top_level) #body')
      .animate({ marginTop: amount }, speed)
    if $('.sidemenu').length
      $('.sidemenu, .editor, #wmd-fields, #wmd-preview, #mailbox, #message, #message header .actions, #calendar')
        .animate({ top: (amount + 70) + 'px' }, speed)


jQuery(document).ready ($) ->

  # Improved select box functionality
  $('body')
    .on 'mouseenter mouseleave', '.select', ->
      $(@).scrollTop 0
      $(@).find('ul').scrollTop 0
    .on 'scroll', '.select, .select ul', ->
      $(@).scrollLeft 0
    .on 'click', '.select ul label, form .profile label', ->
      select = $(@).closest '.select'
      select.scrollTop 0
      ul = $(@).closest 'ul'
      ul.scrollTop(0).animate opacity: 0, 200, ->
        ul.hide().animate opacity: 0, 50, ->
          ul.show().css opacity: 1
  
  # dynamic loaded content after page load
  $('body')
    .on 'ajax:before', '.dynload', ->
      $($(@).attr('data-target')).addClass('busy')      
    #.on 'ajax:error', '.dynload', (xhr, status, error) ->
    #  $.alert body: $(@).attr('data-error') if errormsg
    .on 'ajax:success', '.dynload', (event, data, status, xhr) ->
      $($(@).attr('data-target'))
        .removeClass('busy')
        .html(xhr.responseText)
  $('.dynload:not(.wait)').trigger 'click'
  
  # replace derp avatars with default
  $('.avatar img, img.avatar').bind 'error', ->
    if $(@).css('width')
      width = $(@).css('width').replace /[^\d]/g, ''
    else
      width = $(@).closest('.avatar').width()
    src = $(@).attr('src')
    avatar = '/assets/application/avatar@'+width+'.png'
    $(@)
      .attr('src', avatar)
      .unbind 'error'
  
  # Override rails allow action (for data-confirm)
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
  
  # Batch actions
  $('form .batch button, form button.batch')
    .click ->    
      $(@)
        .closest('form')
        .prop({ action: $(@).attr('action') })
        .find('input[name="_method"]')
        .val $(@).attr('method')

  # Flash message events
  $('body').on 'init', '#flash li', ->
    unless $(@).hasClass 'announcement'
      $('<a class="dismiss"></a>')
        .appendTo(@)
        .click ->
          adjustHeaderByFlash(300,-1)
          $(@)
            .closest('li')
            .animate { height: 0, lineHeight: 0 + 'px' }, 300, ->
              $(@).remove()
    $(@)
      .css({ height: 0, lineHeight: 0 })
      .animate({ height: 40 + 'px', lineHeight: 40 + 'px' }, 600)
    $(@).find('.read')
      .on 'ajax:before', ->
        $(@).closest('li').addClass('busy')
      .on 'ajax:error', (xhr, status, error) ->
        row = $(@).closest('li')
        $.alert
          body: error
          action: ->
            row.removeClass('busy')
      .on 'ajax:success', (event, data, status, xhr) ->
        $('#bar .notice a').each ->
          num = $(@).attr('meta') - 1
          if num > 0
            $(@).attr 'meta', num
          else
            $(@).removeAttr 'meta'
        adjustHeaderByFlash(300,-1)
        $(@)
          .closest('li')
          .animate { height: 0, lineHeight: 0 + 'px' }, 300, ->
            if xhr.responseText
              $('#flash').prepend xhr.responseText
              $('#flash li:first').trigger 'init'
            setTimeout adjustHeaderByFlash, 50
            $(@).remove()
  $('#flash li').trigger 'init'
  
  # Tiered form field selection
  $('form .select[affects] input')
    .change ->
      select = $(@).closest('.select')
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
            $(@)
              .prop('disabled', false)
              .prop('readonly', false)
        if affected.find('.select[affects]:visible').length
          affected.find('.select[affects]:visible input:first').trigger 'change'
  $('form .select[affects] input:checked').trigger 'change'
  
  # Tabs
  $('dl.tabs >dt').click ->
    $(@).closest('dl.tabs').find('>dt').removeClass('current')
    $(@).addClass('current')
  if window.location.hash
    $('#tabs .'+window.location.hash.replace('#','')).trigger 'click'
  $('a[href*="#"]').click ->
    link = $(@).attr('href').split('#').pop()
    tab = $('dl.tabs >dt.'+link)
    if(tab.length)
      tab.trigger 'click'
      return false
  
  # Slider input fields
  $('body').on 'init', '.slider', -> $(@).css('width', $(@).find('label').length * 70)
  $('.slider').trigger 'init'
  
  # Inputs that affect the hidden _destroy field
  $('input[toggle_destroy="true"]').change ->
    $(@).prevAll('input[name*="_destroy"]:first').attr('checked', !$(@).prop('checked'))
  
  # Fluid sidebar menu
  $('.sidemenu')
    .find('a, button, .wmd-button')
    .filter('[title]')
    .each ->
      $(@)
        .attr('meta',$(@).attr('title'))
        .removeAttr 'title'
            
  adjustHeaderByFlash(600)
  
  # Global checkbox
  $('body')
    .on 'init', 'thead th.check:not(:has(a))', ->
      rowChecks = $(@).closest('table').find('tbody td.check input')
      $('<a>').appendTo(@).click ->
        if rowChecks.filter(':checked').length == rowChecks.length
          rowChecks.attr 'checked', false
        else
          rowChecks.attr 'checked', true
    .trigger 'init'