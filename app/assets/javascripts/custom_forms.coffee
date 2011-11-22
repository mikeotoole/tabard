$(document).ready ->

  # Remove question link
  $('form.custom_form .questions >li')
    .live 'load', ->
      li = $(this)
      right = $(this).find('.right')
      if $(this).find('>a.remove').size() == 0
        # Remove question link
        $(this)
          .append('<a class="remove">Remove Question</a>')
          .find('.remove')
          .bind 'click', ->
            question = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][_destroy]" type="hidden" value="true">'
            qid = li.attr('question_id')
            q = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][id]" type="hidden" value="'+qid+'">'
            li.slideUp 400, ->
              $(this).replaceWith(question + q)
        # TypeStyle select change action
        $(this)
          .find('.select input')
          .bind 'change', ->
            select = $(this).closest('.select')
            val = select.find('input:checked').val()
            answers = right.find('.answers')
            if val.match /textquestion/i
              right.addClass('hidden')
              answers.find('input')
                .attr('disabled',true)
                .attr('readonly',true)
            else
              right.removeClass('hidden')
              answers.find('input').removeAttr('disabled readonly')
              if answers.find('li').size() == 0
                right.find('.add a').trigger 'click'
        # Add answer link
        right
          .append('<p class="add"><a>Add Answer</a></p>')
          .find('p.add a')
            .bind 'click', ->
              q = li.attr('question')
              div = $(this).closest('div')
              answers = div.find('.answers')
              a = answers.find('>li:last').attr('answer')
              a = if a then a+1 else answers.find('li').size()
              answer = '<li question="'+q+'" answer="'+a+'"><input name="custom_form[questions_attributes]['+q+'][predefined_answers_attributes]['+a+'][body]" type="text"></li>'
              answers.append(answer)
              answers
                .find('>li:last')
                .trigger 'load'
        # Remove answer link
        right.find('.answers li')
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
    .trigger 'load'