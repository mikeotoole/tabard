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

    # invitee list
    (->
        cache = []
        list = []
        
        $invites = $ '#invites'
        $menu = $invites.find '> menu'
        $input = $menu.find '> input'
        $ul = $invites.find '> ul'

        # Pre-populate list of user profile ids (if any)
        $ul.find('li').each ->
            userProfileId = parseInt $(@).find('input.user_profile').val()
            list.push userProfileId if userProfileId > 0

        # Auto-suggest users/characters
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
                if ui.item.value in list
                    $li = $ul.find("li:has(input.user_profile[value=#{ui.item.value}])")
                    if $li.length
                        $li.remove()
                    else if $li.find('input.destroy').length
                        return false
                else 
                    list.push ui.item.value
                _i = (parseInt($ul.find('li:last').attr 'data-index') or 0) + 1
                $ul.append ui.item.html.replace(/_INDEX_/g, _i)
                return false
            source: (request, response) ->
                term = request.term
                return response cache[term] if cache[term]?
                lastXhr = $.getJSON $input.data('url'), request, (data, status, xhr) ->
                    cache[term] = data
                    response data if xhr is lastXhr

        $input.data('autocomplete')._renderItem = (ul, item) ->
            $('<li class="with-avatar">').html(item.label).data('item.autocomplete', item).appendTo ul

        # Remove invites
        $ul.on 'click', '.close', ->
            $li = $(@).closest 'li'
            $id = $li.find 'input.id'
            $profile = $li.find 'input.user_profile'
            userProfileId = $li.find('input.user_profile').val()
            if $id.length
                $destroy = $id.clone()
                $destroy.attr
                    class: 'destroy'
                    name: $id.attr('name').replace '[id]', '[_destroy]'
                    value: 'true'
                $li.empty()
                $li.append $id
                $li.append $profile
                $li.append $destroy
                $li.hide()
            else
                $li.remove()
            list.splice list.indexOf(userProfileId), 1
            false

        # Remove all
        $invites.on 'click', '.none', ->
            $.confirm
                title: 'Remove all invitations?'
                actions:
                    confirm: ->
                        $ul.find('.close').each -> $(@).trigger 'click'
            false

        # Add all members
        $invites.on 'click', '.all', ->
            return false unless window.communityMembers? and window.communityMembers.length > 0
            $ul.find('.close').each -> $(@).trigger 'click'
            for member, _i in window.communityMembers
                $li = $("<li data-index='#{_i}'></li>")
                $a = $("<a href='#{member.url}'>#{member.name}</a>").appendTo $li
                $img = $("<img src='#{member.avatar}' alt=''>").prependTo $a
                $close = $("<span class='close'></span>").appendTo $a
                $profile = $("<input type='hidden'>").attr
                    class: 'user_profile'
                    name: "event[invites_attributes][#{_i}][user_profile_id]"
                    value: member.id
                $profile.appendTo $li
                $_li = $ul.find("li:has(input.user_profile[value=#{member.id}])")
                if $_li.length
                    $_li.find('input.id').clone().appendTo $li
                    $_li.remove()
                $li.appendTo $ul
                list.push member.id
            false

    )()