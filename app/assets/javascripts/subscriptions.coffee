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
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
      name: $('#card_name').val()
      addressZip: $('#card_address_zip').val()
    Stripe.createToken card, @handleStripeResponse

  handleStripeResponse: (status, response) ->
    if status is 200
      $('#stripe_card_token').val(response.id)
      $('#form_with_subscription')[0].submit()
    else
      $.flash 'error', response.error.message
      $('input[type=submit]').prop 'disabled', false


jQuery(document).ready ($) ->

  curMemberCount = $('#population .value').data 'value'
  curMemberCount = 150
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
    $('#population').attr 'data-max', "#{newMemberMax} Members Max"
    $('#population .value').css minWidth: "#{Math.round(curMemberCount / newMemberMax * 1000) / 10}%"

    # Destroy package on/off
    if data.destroy?
      destroyEl = $("input[data-destroy='#{data.destroy}']")
      destroyEl.val if parseInt(val) is 0 then 'true' else 'false'