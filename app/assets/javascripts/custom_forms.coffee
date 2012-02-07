$(document).ready ->
  
  $('form.custom_form')
    .delegate '.questions > li', 'init', ->
      li = $(this)
      right = $(this).find('.right')
      li.data('qstyle',li.attr('question_style'))
      if $(this).find('>a.remove').size() == 0
        # Remove question link
        li
          .append('<a class="remove">Remove Question</a>')
          .find('>.remove')
          .click ->
            if li.filter('[question_id]').length
              question = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][_destroy]" type="hidden" value="true">'
              qid = li.attr 'question_id'
              q = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][id]" type="hidden" value="'+qid+'">'
              li.slideUp 400, ->
                $(this).replaceWith(question + q)
            else
              li.slideUp 400, ->
                $(this).remove()
        
        # TypeStyle select change action
        li
          .find('.select input')
          .change ->
            select = $(this).closest('.select')
            answers = right.find('.answers')
            checkedInput = select.find('input:checked')
            val = checkedInput.val()
            select.find('input').removeAttr 'checked'
            checkedInput.attr 'checked','checked'
            if val.match /short_answer_question|long_answer_question/i
              right.addClass('hidden')
              answers.find('input')
                .attr('disabled',true)
                .attr('readonly',true)
            else
              right.removeClass('hidden')
              if val == li.data('qstyle')
                answers.find('input').removeAttr('disabled readonly')
              else
                answers.find('input[type="hidden"]')
                  .attr('disabled',true)
                  .attr('readonly',true)
                answers.find('input[type="text"]')
                  .removeAttr('disabled readonly')
              if answers.find('li').size() == 0
                right.find('.add a').trigger 'click'
        
        # Add answer link
        right.find('p.add').removeClass('hidden')
        
        # Remove answer link
        right.find('.answers').delegate 'li a.remove', 'click', ->
          ali = $(this).closest('li')
          ali.slideUp 400, ->
            if ali.attr 'question'
              answer = '<input name="custom_form[questions_attributes]['+ali.attr('question')+'][predefined_answers_attributes]['+ali.attr('answer')+'][_destroy]" type="hidden" value="true">'
              $(this).replaceWith(answer)
      
      li.find('.select input:checked').trigger 'change'
      
  $('form.custom_form .questions > li').trigger 'init'