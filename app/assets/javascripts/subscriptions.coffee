jQuery ->
  Stripe.setPublishableKey $('meta[name="stripe-key"]').attr 'content'
  card.setup()

card =
  setup: ->
    $('#form_with_subscription').submit ->
      return true unless $('#cc_fields:visible').length
      
      # Encourage all fields being filled out
      errCount = 0
      for field in $(@).find('input[type=text]')
        $field = $(field)
        $li = $field.closest 'li'
        if $field.val()
          $li.removeClass 'error'
        else
          errCount++
          $li.addClass 'error'
      for select in $(@).find('.select')
        $select = $(select)
        if $select.find('input:checked').length
          $select.removeClass 'error'
        else
          errCount++
          $select.addClass 'error'

      # Errors present?
      if errCount > 0
        $.flash 'alert cardfields', 'Please fill out missing fields.' unless $('#flash .cardfields').length

      # Disable submit and process request
      else
        if requireConfirmation
          $.confirm
            title: 'Confirm Charge'
            body: 'This will submit a payment with the card you provided and configure your recurring monthly subscription.'
            action: -> card.process()
        else
          card.process()
      false

  process: ->
    $('#flash .cardfields .dismiss').trigger 'click'
    $('#form_with_subscription input[type=submit]').prop 'disabled', true
    data =
      name: $('#card_name').val()
      number: $('#card_number').val()
      cvc: $('#card_cvc').val()
      expMonth: $('#card_exp_month input:checked').val()
      expYear: $('#card_exp_year input:checked').val()
      addressLine1: $('#card_address').val()
      addressCity: $('#card_city').val()
      addressState: $('#card_state').val()
      addressZip: $('#card_zip').val()
    $('body').addClass 'busy'
    Stripe.createToken data, @handleStripeResponse

  handleStripeResponse: (status, response) ->
    $('body').removeClass 'busy'

    # Remove old error messages
    $('#flash li').each -> $(@).find('.dismiss').trigger 'click'
    $('#form_with_subscription li').removeClass('with-errors').find('mark.error').remove()

    # Success, so submit the data to Stripe
    if status is 200
      ccFields = $('#cc_fields').find 'input'
      $('#stripe_card_token').val response.id
      ccFields.attr 'disabled', 'disabled'
      $('#form_with_subscription')[0].submit()
      ccFields.removeAttr 'disabled'

    else
      # Show message in DOM
      if response.error.param.match /exp_year|exp_month/
        errorMsg = 'Invalid expiration date.'
      else
        errorMsg = response.error.message
      $.flash 'alert', errorMsg
      li = $("#card_#{response.error.param}").closest('li')
      li.addClass 'with-errors'
      $('<mark class="error">').appendTo(li).text errorMsg

      # Re-enable submit button
      $('#form_with_subscription input[type=submit]').removeAttr 'disabled'


jQuery(document).ready ($) ->

  curMemberCount = $('#population .value').data 'value'
  totNeededPacks = if curMemberCount <= 100 then 0 else Math.ceil (curMemberCount - 100) / 20

  # Update the values of the community population percentage bar
  updatePopulationBar = () ->
    maxMembers = getMaxMemberCount()
    newPercentage = Math.round(curMemberCount / maxMembers * 1000) / 10
    newPercentage = 100 if newPercentage > 100
    $('#population').attr 'data-max', "#{maxMembers} Members Max"
    $('#population .value').css minWidth: "#{newPercentage}%"
    if maxMembers is curMemberCount
      $('#population').addClass 'full'
    else if maxMembers < curMemberCount
      $('#population').addClass 'overage'
    else
      $('#population').removeClass 'full overage'

  # Get the current number of extra members via the package upgrade
  getMaxMemberCount = ->
    formEl = $('#form_with_subscription')
    base = parseInt formEl.find('.plans input:checked').attr 'data-members'
    extra = parseInt formEl.find('.members_package:visible input:checked').val() or 0
    base + extra * 20

  # Toggling between packages
  $('#form_with_subscription').on 'change', '.plans input', ->
    price = parseInt $(@).attr 'data-price'
    if price
      $('#upgrades, #cc_input').slideDown()
    else
      $('#upgrades, #cc_input').hide()
    updatePopulationBar()
  $('#form_with_subscription .plans input:checked').trigger 'change'

  # Toggling new/onfile card
  $('#cc_input menu')
    .on 'click', '.onfile', ->
      $('#cc_input').removeClass 'show_fields'
      $('#cc_fields').hide()
    .on 'click', '.newcard', ->
      $('#cc_input').addClass 'show_fields'
      $('#cc_fields').slideDown()

  # Get the number of packages required to keep the community afloat
  if totNeededPacks > 0
    for input in $('body .select.members_package input')
      $input = $(input)
      if $input.val() < totNeededPacks
        $input.closest('li').addClass 'warn'
      else
        break

  # When the package upgrades change
  $('body').on 'change', '.select.members_package input', ->
    updatePopulationBar()

    # Destroy package on/off
    data = $(@).closest('.select').data()
    if data.destroy?
      destroyEl = $("input[data-destroy='#{data.destroy}']")
      destroyEl.val if parseInt(val) is 0 then 'true' else 'false'