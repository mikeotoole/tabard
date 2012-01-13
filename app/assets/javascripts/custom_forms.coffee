$(document).ready ->
  
  $('form.custom_form')
    .delegate '.questions > li', 'init', ->
      li = $(this)
      right = $(this).find('.right')
      li.data('qtype',li.attr('question_type'))
      if $(this).find('>a.remove').size() == 0
        # Remove question link
        li
          .append('<a class="remove">Remove Question</a>')
          .find('>.remove')
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
            answers = right.find('.answers')
            checkedInput = select.find('input:checked')
            val = checkedInput.val()

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
            
            select.find('input').removeAttr 'checked'
            checkedInput.attr 'checked','checked'
            if li.attr 'question_id' > 0
              oldIdQ = li.attr 'question_id'
              oldIndexQ = li.attr 'question'
              li.before '<input name="custom_form[questions_attributes]['+oldIndexQ+'][_destroy]" type="hidden" value="true"><input name="custom_form[questions_attributes]['+oldIndexQ+'][id]" type="hidden" value="'+oldIdQ+'">'
              li.find('input[type="hidden"]').remove()
              $('#custom_form_questions_attributes_'+oldIndexQ+'_id').remove()
            newIndexQ = new Date().getTime()
            html = li.html()
            html = html.replace(/(\[questions_attributes\]\[)\d(\])/g, "$1"+newIndexQ+"$2")
            html = html.replace(/(custom_form_questions_attributes_)\d/g, "$1"+newIndexQ)
            html = html.replace(/question=\"\d\"/g, '')
            li
              .removeAttr('question_id question_type')
              .attr('question', newIndexQ)
              .html(html)
            li.find('>a.remove').remove()
        
        # Add answer link
        right.find('p.add').removeClass('hidden')
        
        # Remove answer link
        right.find('.answers').delegate 'li a.remove', 'click', ->
          ali = $(this).closest('li')
          if ali.attr 'question'
            answer = '<input name="custom_form[questions_attributes]['+ali.attr('question')+'][predefined_answers_attributes]['+ali.attr('answer')+'][_destroy]" type="hidden" value="true">'
          ali.slideUp 400, ->
            $(this).replaceWith(answer)
      
      # li.find('.select input:checked').trigger 'change'
      
  $('form.custom_form .questions > li').trigger 'init'