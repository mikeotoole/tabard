$(document).ready ->

  # change theme
  $('label[for="community_theme_id"] + ul input').change ->
    theme = $(this).find('+ label img').attr 'theme'
    $('head link.theme').attr 'href', '/assets/themes/' + theme + '.css'

  # background color
  $('#community_background_color').closest('.color').each ->
    input_bg_color = $('#community_background_color')
    color = '#' + input_bg_color.val()
    input_bg_color.after '<div class="preview"></div>'
    $('#content').css 'background-color', color
    input_bg_color.next('.preview').css 'background', color
    input_bg_color.ColorPicker
      color: color
      onChange: (hsb, hex, rgb) ->
        $('#content').css 'background-color', '#' + hex
        input_bg_color.val(hex).next('.preview').css 'background', '#' + hex

  # title color
  $('#community_title_color').closest('.color').each ->
    input_bg_color = $('#community_title_color')
    color = '#' + input_bg_color.val()
    input_bg_color.after '<div class="preview"></div>'
    $('#header .title').css 'color', color
    input_bg_color.next('.preview').css 'background', color
    input_bg_color.ColorPicker
      color: color
      onChange: (hsb, hex, rgb) ->
        $('#header .title').css 'color', '#' + hex
        input_bg_color.val(hex).next('.preview').css 'background', '#' + hex