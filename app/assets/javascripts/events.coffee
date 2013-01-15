jQuery(document).ready ($) ->

    # Date Picker
    $('#event_start_time_date, #event_end_time_date').each ->
        datef = $(@)
        nicef = datef.closest('li').find('input.nicedate')
        datef.datepicker
            minDate: 0
            dateFormat: 'yy-mm-dd'
            altField: nicef
            altFormat: 'DD, MM d, yy'
            showOn: "button"
        nicef.bind 'click focus', ->
            nicef.blur()
            datef.datepicker 'show'

    # Hour/min field
    $('#event').on 'change blur', '.time input', ->
        val = $(@).val()
        val += 'pm' unless val.match /a|p\.*m/i
        $(@).val moment(val,'h:mm a').format 'h:mm a'

    # Game dropdown character filtering
    $('label[for="event_community_game_id"] + ul input[type="radio"]').change ->
        sgId = $(@).closest('ul').find('input[type="radio"]:checked').val()
        chars = $('table.invites tbody td.characters ul li')
        if sgId
            chars.hide()
            chars.find('img.sg_'+sgId).closest('li').show()
        else
            chars.show()
        false
    
    # Toggle action for rows
    $('table.invites td.actions a.toggle').click ->
        row = $(@).closest('tr')
        if $(@).hasClass('approve')
            $(@).removeClass('approve').addClass('reject')
            row.addClass 'dim'
            row.find('input[name*="_destroy"]').val(true)
        else
            $(@).removeClass('reject').addClass('approve')
            row.removeClass 'dim'
            row.find('input[name*="_destroy"]').val(false)
        return false
    
    # Global checkbox for rows
    $('table.invites thead th:last').each ->
        invitedRows = $(@).closest('table').find('tbody tr')
        if invitedRows.length > 0
            checka = $('<a>').appendTo @
            checka.addClass('checked') if invitedRows.find('td.actions a.approve').length == invitedRows.length
            checka.click ->
                if invitedRows.find('td.actions a.approve').length == invitedRows.length
                    invitedRows
                        .find('td.actions a.toggle')
                        .removeClass('reject')
                        .addClass('approve')
                        .trigger 'click'
                else
                    invitedRows
                        .find('td.actions a.toggle')
                        .removeClass('approve')
                        .addClass('reject')
                        .trigger 'click'
                false
        false

    # Autocomplete invitee list
    (->
        cache = []
        list = []
        
        $invites = $ '#invites'
        $menu = $invites.find '> menu'
        $input = $menu.find '> input'
        $ul = $invites.find '> ul'

        $input.autocomplete
            autoFocus: false
            create: (e, ui) ->
                $('ul.ui-autocomplete li:has(img)').addClass 'with-avatar'
            delay: 300
            focus: (e, ui) ->
                $input.val ui.item.display_name
                return false
            minLength: 2
            open: (e, ui) ->
                $input.autocomplete('widget').width $input.width() + 8
            position:
                my: 'left top'
                at: 'left bottom'
                offset: '0, -3'
                collision: 'none'
            select: (e, ui) ->
                $input.val ''
                return false if ui.item.value in list
                list.push ui.item.value
                console.log ui.item.html
                $ul.append ui.item.html.replace(/_INDEX_/g, parseInt($ul.find('li:last').attr 'data-index') + 1)
                return false
            source: (request, response) ->
                term = request.term
                return response cache[term] if cache[term]?
                lastXhr = $.getJSON $input.data('url'), request, (data, status, xhr) ->
                    cache[term] = data
                    response data if xhr is lastXhr

        $input.data('autocomplete')._renderItem = (ul, item) ->
            $('<li class="with-avatar">').html(item.label).data('item.autocomplete', item).appendTo ul

        $ul.on 'click', '.close', ->
            $(@).closest('li').remove()
            updateMessageHeaderHeight()

        $ul.find('li').each -> list.push parseInt $(@).val()

    )()