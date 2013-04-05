jQuery ->
    Stripe.setPublishableKey $('meta[name="stripe-key"]').attr 'content'
    card.setup()

card =
    setup: ->
        $('#card_form').submit ->
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
                        body: 'Your current statement will be processed with this request.'
                        actions:
                            confirm: -> card.process()
                else
                    card.process()
            false

    process: ->
        $('#flash .cardfields .dismiss').trigger 'click'
        $('#card_form input[type=submit]').prop 'disabled', true
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
        # Remove old error messages
        $('#flash li').each -> $(@).find('.dismiss').trigger 'click'
        $('#card_form li').removeClass('with-errors').find('mark.error').remove()

        # Success, so submit the data to Stripe
        if status is 200
            ccFields = $('#card_form li input')
            $('#stripe_card_token').val response.id
            ccFields.attr 'disabled', 'disabled'
            $('#card_form')[0].submit()
            ccFields.removeAttr 'disabled'

        else
            $('body').removeClass 'busy'

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
            $('#card_form input[type=submit]').removeAttr 'disabled'