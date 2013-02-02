jQuery(document).ready ($) ->

    $('#search').focus()

    cache = []

    $('#search').autocomplete
        autoFocus: false
        create: (e, ui) ->
            $('ul.ui-autocomplete li:has(img)').addClass 'with-avatar'
        delay: 300
        minLength: 2
        open: (e, ui) ->
            $(@).autocomplete('widget').width $(@).width() + 8
        position:
            my: 'left top'
            at: 'left bottom'
            offset: '0, -3'
            collision: 'none'
        select: (e, ui) ->
            window.location = ui.item.url
        source: (request, response) ->
            term = request.term
            return response cache[term] if cache[term]?
            lastXhr = $.getJSON $('#search').data('url'), request, (data, status, xhr) ->
                cache[term] = data
                response data if xhr is lastXhr

    $('#search').data('autocomplete')._renderItem = (ul, item) ->
        li = $('<li>').data('item.autocomplete', item).appendTo ul
        html = '<a>'
        if item.avatar?
            li.addClass 'with-avatar'
            html += "<img src='#{item.avatar}' alt=''>"
        html += "#{item.label}</a>"
        li.html html
        return li

    $.endlessPageInit() if $('ol.results li').length