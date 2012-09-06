jQuery ->
  Stripe.setPublishableKey $('meta[name="stripe-key"]').attr 'content'
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#form_with_subscription').submit ->
      if $('#card_number').length
        $(@).find('input[type=submit]').prop 'disabled', true
        subscription.processCard()
        false
      else
        true

  processCard: ->
    card =
      name: $('#card_name').val()
      number: $('#card_number').val()
      cvc: $('#card_cvc').val()
      expMonth: $('#card_exp_month input:checked').val()
      expYear: $('#card_exp_year input:checked').val()
      addressZip: $('#card_address_zip').val()
    Stripe.createToken card, @handleStripeResponse

  handleStripeResponse: (status, response) ->
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
      console.log response.error
      if response.error.param.match /exp_year|exp_month/
        errorMsg = 'Invalid expiration date.'
      else
        errorMsg = response.error.message
      $.flash 'alert', errorMsg
      li = $("#card_#{response.error.param}").closest('li')
      li.addClass 'with-errors'
      $('<mark class="error">').appendTo(li).text errorMsg

      # Re-enable submit button
      $('input[type=submit]').removeAttr 'disabled'


jQuery(document).ready ($) ->

  curMemberCount = $('#population .value').data 'value'
  totNeededPacks = if curMemberCount <= 100 then 0 else Math.ceil (curMemberCount - 100) / 20

  if totNeededPacks > 0
    for input in $('body .select.members_package input')
      $input = $(input)
      if $input.val() < totNeededPacks
        $input.closest('li').addClass 'warn'
      else
        break

  $('body').on 'change', '.select.members_package input', ->
    selectEl = $(@).closest '.select'
    data = selectEl.data()
    val = selectEl.find('input:checked').val()

    # Update population percentage bar
    newMemberMax = 100 + val * 20
    newPercentage = Math.round(curMemberCount / newMemberMax * 1000) / 10
    newPercentage = 100 if newPercentage > 100
    $('#population').attr 'data-max', "#{newMemberMax} Members Max"
    $('#population .value').css minWidth: "#{newPercentage}%"
    if newMemberMax is curMemberCount
      $('#population').addClass 'full'
    else if newMemberMax < curMemberCount
      $('#population').addClass 'overage'
    else
      $('#population').removeClass 'full overage'

    # Destroy package on/off
    if data.destroy?
      destroyEl = $("input[data-destroy='#{data.destroy}']")
      destroyEl.val if parseInt(val) is 0 then 'true' else 'false'