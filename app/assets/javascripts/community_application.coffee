$(document).ready ->

  # Character selections
  $('form.community_application .sidebar .characters .select label')
    .bind 'click', ->
      select = $(this).closest('.select')
      select.before($(this).clone())
  $('form.community_application .sidebar .characters .select input[type="checkbox"]')
    .bind 'change', ->
      select = $(this).closest('.select')
      inputs = select.find('input[type="checkbox"]')
      if inputs.length == inputs.filter(':checked').length
        select.hide()
      else
        select.show()
  $('form.community_application .sidebar .characters > label')
    .live 'click', ->
      $(this).remove()