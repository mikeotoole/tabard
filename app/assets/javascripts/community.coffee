jQuery(document).ready ($) ->

  $(document).scroll ->
    scrollY = $(window).scrollTop()
    flashH = $('#flash').height() + 20
    if scrollY < 160 + flashH
      $('body').removeClass 'fixed-menu'
    else
      $('body').addClass 'fixed-menu'