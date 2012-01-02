$(document).ready ->
  
  $('form.custom_form .questions')
    .delegate 'li', 'init', ->
      li = $(this)
      right = $(this).find('.right')
      li.data('qtype',li.attr('question_type'))
      if $(this).find('>a.remove').size() == 0
        
        # Remove question link
        li
          .append('<a class="remove">Remove Question</a>')
          .find('.remove')
          .click ->
            question = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][_destroy]" type="hidden" value="true">'
            qid = li.attr('question_id')
            q = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][id]" type="hidden" value="'+qid+'">'
            li.slideUp 400, ->
              $(this).replaceWith(question + q)
        
        # TypeStyle select change action
        li
          .find('.select input')
          .change ->
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
              if val == li.data('qtype')
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
          li = $(this).closest('li')
          answer = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][predefined_answers_attributes]['+li.attr('answer')+'][_destroy]" type="hidden" value="true">'
          li.slideUp 400, ->
            $(this).replaceWith(answer)
      
  $('form.custom_form .questions >li').trigger 'init'