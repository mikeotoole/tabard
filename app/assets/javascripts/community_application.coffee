$(document).ready ->

  # Character selections
  $('form.community_application .sidebar .characters .select label')
    .bind 'click', ->
      select = $(this).closest('.select')
      select.before $(this).clone()
  $('form.community_application .sidebar .characters .select input[type="checkbox"]')
    .change ->
      select = $(this).closest('.select')
      inputs = select.find('input[type="checkbox"]')
      if inputs.length == inputs.filter(':checked').length
        select.hide()
      else
        select.show()
    .filter(':first')
    .trigger 'change'
  $('form.community_application .sidebar').delegate '.characters > label', 'click', ->
    $(this).hide()