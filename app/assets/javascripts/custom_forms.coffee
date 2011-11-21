$(document).ready ->

  # Removal links
  $('form.custom_form >fieldset >ul >li, form.custom_form .answers li')
    .one 'load', ->
      $(this)
        .append('<a class="remove">Remove</a>')
        .find('.remove')
        .bind 'click', ->
          $(this)
            .closest('li')
            .slideUp 400, ->
              $(this).remove()
    .trigger 'load'