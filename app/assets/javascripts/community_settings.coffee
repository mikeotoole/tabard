jQuery(document).ready ($) ->

    # change theme
    $('input[id^="community_theme_id"]').change ->
        theme = $(@).find('+ label img').attr 'theme'
        $('head link.theme').attr 'href', "/assets/themes/#{theme}.css"

    # background color
    $('#community_background_color').closest('.color').each ->
        input_bg_color = $('#community_background_color')
        color = '#' + input_bg_color.val()
        input_bg_color.after '<div class="preview"></div><a class="reset">Reset</a>'
        $('body, #content').css 'background-color', color
        input_bg_color.siblings('.preview').css 'background', color
        input_bg_color.siblings('.reset').click ->
            input_bg_color.val ''
            input_bg_color.siblings('.preview').css 'background', ''
            $('body').removeClass 'theme'
            $('body, #content').css 'background-color', ''
            return false
        input_bg_color.ColorPicker
            color: color
            onChange: (hsb, hex, rgb) ->
                $('body, #content').css 'background-color', "##{hex}"
                input_bg_color.val(hex).next('.preview').css 'background', "##{hex}"

    # title color
    $('#community_title_color').closest('.color').each ->
        input_title_color = $('#community_title_color')
        color = '#' + input_title_color.val()
        input_title_color.after '<div class="preview"></div><a class="reset">Reset</a>'
        $('#header .title').css 'color', color
        input_title_color.siblings('.preview').css 'background', color
        input_title_color.siblings('.reset').click ->
            input_title_color.val ''
            input_title_color.siblings('.preview').css 'background', ''
            $('body').removeClass 'theme'
            $('#content, .title').css { color: '', textShadow: '' }
            return false
        input_title_color.ColorPicker
            color: color
            onChange: (hsb, hex, rgb) ->
                $('#header .title').css { color: "##{hex}", textShadow: 'none' }
                input_title_color.val(hex).next('.preview').css 'background', "##{hex}"