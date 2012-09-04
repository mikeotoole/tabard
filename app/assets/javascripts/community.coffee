jQuery(document).ready ($) ->

  $(document).scroll ->
    scrollY = $(window).scrollTop()
    if scrollY < 160
      $('body').removeClass 'fixed-menu'
    else
      $('body').addClass 'fixed-menu'