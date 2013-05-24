jQuery(document).ready ($) ->

    $('#tabs')
        .on 'ajax:before', 'dt > a', ->
            $this = $(@)
            $this.data 'type', 'json'
            $this.closest('dl').addClass 'busy'
        # Announcements
        .on 'ajax:error', 'dt.announcements + dd form', (xhr, status, error) ->
            $.alert 'Unable to mark announcements as read.'
        .on 'ajax:complete', 'dt.announcements + dd form', (event, data, status, xhr) ->
            $('#tabs dt.announcements a').trigger 'click'
        # Update window history on tab switching
        .on 'ajax:success', 'dt > a', (event, data, status, xhr) ->
            return false unless !!data.success
            $this = $(@)
            $dt = $this.closest 'dt'
            $dl = $dt.closest 'dl'
            $dd = $dt.find '+dd'
            $dd.html data.html
            $dl.removeClass 'busy'
            $dl.find('>dt').removeClass 'current'
            $dt.addClass 'current'
            if typeof(history.replaceState) is typeof(Function)
                hash = $dt.prop('class').split(' ').shift()
                history.replaceState {}, $this.text(), "##{hash}"

    # Batch invites action
    $('#body')
        .on 'ajax:error', '#invites_batch', (xhr, status, error) ->
            $.alert error
        .on 'ajax:success', '#invites_batch', (event, data, status, xhr) ->
            response = $.parseJSON xhr.responseText
            if response.success
                $("#invites_batch tr[invite='#{invite.id}'] td.status strong").text invite.status for invite in response.invites
                $("#invites_batch td.check input").removeAttr 'checked'
                if response.fresh_invites_count > 0
                    $('#bar .dashboard .calendar a').attr 'meta', response.fresh_invites_count
                else
                    $('#bar .dashboard .calendar a').removeAttr 'meta'
            else
                $.alert response.message

    # Games/Characters
    $('#body').on 'click', '#tabs dt.games + dd h2', (e) ->
        $(@).toggleClass 'closed' if @ is e.target