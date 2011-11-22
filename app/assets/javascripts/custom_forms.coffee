$(document).ready ->

  # Remove question link
  $('form.custom_form .questions >li')
    .live 'load', ->
      $(this)
        .append('<a class="remove">Remove Question</a>')
        .find('.remove')
        .bind 'click', ->
          li = $(this).closest('li')
          question = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][_destroy]" type="hidden" value="true">'
          qid = li.attr('question_id')
          q = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][id]" type="hidden" value="'+qid+'">'
          li.slideUp 400, ->
            $(this).replaceWith(question + q)
      $(this)
        .find('.select input')
        .bind 'change', ->
          select = $(this).closest('.select')
          li = select.closest('li')
          val = select.find('input:checked').val()
          right = li.find('.right')
          answers = right.find('.answers')
          if val.match /textquestion/i
            right.addClass('hidden')
            answers.find('input').attr('readonly',true)
          else
            right.removeClass('hidden')
            answers.find('input').removeAttr('readonly')
            if answers.find('li').size() == 0
              right.find('.add a').trigger 'click'
  .trigger 'load'
    
  # Add answer link
  $('form.custom_form .right')
    .append('<p class="add"><a>Add Answer</a></p>')
    .find('p.add a')
      .bind 'click', ->
        li = $(this).closest('li')
        q = li.attr('question')
        div = $(this).closest('div')
        answers = div.find('.answers')
        a = answers.find('>li:last').attr('answer') + 1
        answer = '<li question="'+q+'" answer="'+a+'"><input name="custom_form[questions_attributes]['+q+'][predefined_answers_attributes]['+a+'][body]" type="text"></li>'
        answers.append(answer)
        answers
          .find('>li:last')
          .trigger 'load'
    
  # Remove answer link
  $('form.custom_form .answers li')
    .live 'load', ->
      $(this)
        .append('<a class="remove">Remove Answer</a>')
        .find('.remove')
        .bind 'click', ->
          li = $(this).closest('li')
          answer = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][predefined_answers_attributes]['+li.attr('answer')+'][_destroy]" type="hidden" value="true">'
          li.slideUp 400, ->
            $(this).replaceWith(answer)
    .trigger 'load'