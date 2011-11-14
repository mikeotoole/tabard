$(document).ready ->

  # Character selections
  $('#new_community_application .sidebar .characters .select label')
    .bind 'click', ->
      select = $(this).closest('.select')
      select.before($(this).clone())
  $('#new_community_application .sidebar .characters .select input[type="checkbox"]')
    .bind 'change', ->
      select = $(this).closest('.select')
      inputs = select.find('input[type="checkbox"]')
      if inputs.length == inputs.filter(':checked').length
        select.hide()
      else
        select.show()
  $('#new_community_application .sidebar .characters > label')
    .live 'click', ->
      $(this).remove()