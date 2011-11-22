$(document).ready ->

  # Remove question link
  $('form.custom_form >fieldset >ul >li')
    .one 'load', ->
      $(this)
        .append('<a class="remove">Remove Question</a>')
        .find('.remove')
        .bind 'click', ->
          li = $(this).closest('li')
          q = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][_destroy]" type="hidden" value="true">'
          qid = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][id]" type="hidden" value="'+li.attr('question_id')+'">'
          li.slideUp 400, ->
            $(this).replaceWith(q+qid)
    .trigger 'load'
    
  # Remove answer link
  $('form.custom_form .answers li')
    .one 'load', ->
      $(this)
        .append('<a class="remove">Remove Answer</a>')
        .find('.remove')
        .bind 'click', ->
          li = $(this).closest('li')
          a = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][predefined_answers_attributes]['+li.attr('answer')+'][_destroy]" type="hidden" value="true">'
          li.slideUp 400, ->
            $(this).replaceWith(a)
    .trigger 'load'