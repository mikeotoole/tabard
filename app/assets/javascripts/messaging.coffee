$(document).ready ->

  $('#mailbox .meta input[type="checkbox"]')
    .bind 'click change', ->
      if $(this).filter(':checked').length
        $(this).closest('dd').addClass 'selected'
      else
        $(this).closest('dd').removeClass 'selected'