//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require skylite.min


# global var access
root = exports ? this


((jQuery) ->

    modalOptions =
        cssIn: {opacity: 0, top: '45%'}
        animIn: [{opacity: 1, top: '50%'}, 200]
        animOut: [{opacity: 0, top: '55%'}, 400]

    $.alert = (options) ->
        options = body: options if typeof(options) is 'string'
        $.extend options, modalOptions
        options.type = 'alert'
        new Skylite options

    $.confirm = (options) ->
        $.extend options, modalOptions
        options.type = 'confirm'
        options.actions = $.extend {cancel: (-> true)}, options.actions unless options.actions.cancel?
        new Skylite options

    $.prompt = (options) ->
        $.extend options, modalOptions
        options.type = 'prompt'
        options.body = '' unless options.body?
        options.body += '<p><input type="text" class="prompt" /></p>'
        options['require'] = true unless options.require?
        options.actions = $.extend {cancel: (-> true)}, options.actions unless options.actions.cancel?
        modal = new Skylite options
        setTimeout (-> modal.$modal.find('.prompt').focus()), 10
        modal

    $.profile = (options) ->
        $.extend options, modalOptions
        options.type = 'profile'
        options.actions = $.extend {
            'Assign Roles': ((modal) ->
                errMsg = 'Error: unable to load roles.'
                $.ajax
                    url: options.url.replace(/\.js$/, '/roles.js')
                    type: 'get'
                    dataType: 'text'
                    error: (xhr, status, error) ->
                        $.alert error ? errMsg
                    success: (data, status, xhr) ->
                        response = $.parseJSON data
                        return unless response.success and response.html?
                        node
                            .attr('current_page', next_page)
                            .find(node.attr('target'))
                            .append response.html
                return false
            ),
            message: ((modal) -> document.location = modal.$modal.find('.avatar').attr('href').replace('/profiles/', 'mail/compose/')),
            'View Profile': ((modal) -> document.location = modal.$modal.find('.avatar').attr('href')),
            close: (-> true)
        }, (options.actions ? {})
        new Skylite options

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

    # dynamic loaded content after page load
    $('body')
        .on 'ajax:before', '.dynload', ->
            $($(@).attr('data-target')).addClass('busy')            
        #.on 'ajax:error', '.dynload', (xhr, status, error) ->
        #    $.alert $(@).attr('data-error') if errormsg
        .on 'ajax:success', '.dynload', (event, data, status, xhr) ->
            $($(@).attr('data-target'))
                .removeClass('busy')
                .html(xhr.responseText)
    $('.dynload:not(.wait)').trigger 'click'

    # Wire links to profile modals
    $('body')
        .on 'ajax:before', 'a.profile[data-remote], a.avatar[data-remote]', ->
            $(@).data 'type', 'json'
        .on 'ajax:error', 'a.profile[data-remote], a.avatar[data-remote]', (xhr, status, error) ->
            $.alert error
        .on 'ajax:success', 'a.profile[data-remote], a.avatar[data-remote]', (event, data, status, xhr) ->
            if data.success
                $.profile html: data.html, url: $(@).attr 'href'
            else
                $.alert data.text

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
                actions:
                    continue: ->
                        element.data 'affirm', yes
                        element.click()
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
                    actions:
                        ok: -> row.removeClass('busy')
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
            $(@).attr('meta',$(@).attr 'title').removeAttr 'title'

    adjustHeaderByFlash 600

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