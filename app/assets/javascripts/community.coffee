jQuery(document).ready ($) ->

  $(document).scroll ->
    scrollY = $(window).scrollTop()
    padY = 160
    padY += $('#flash').height()
    padY += 80 if $('body').hasClass 'with_action_items'
    
    if scrollY < padY
      $('body').removeClass 'fixed-menu'
    else
      $('body').addClass 'fixed-menu'