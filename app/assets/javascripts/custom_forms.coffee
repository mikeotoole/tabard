$(document).ready ->

  $('form.custom_form >fieldset >ul >li')
    .live 'load', ->
      $(this)
        .append('<a class="remove">Remove</a>')
        .find('.remove')
        .bind 'click', ->
          $(this)
            .closest('li')
            .slideUp 400, ->
              $(this).remove()
    .trigger 'load'