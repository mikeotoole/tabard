###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# Controller used to edit card information
###
class CardController < PaymentController
  respond_to :html, :js

###
# Callbacks
###
  skip_before_filter :ensure_not_ssl_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain

  # GET /card
  def edit
    @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token) unless current_user.stripe_customer_token.blank?
    @invoice = current_user.current_invoice
    @invoice = nil unless (@invoice.period_end_date < Time.now and @invoice.total_price_in_cents > 0)
  end

  # PUT /card
  def update
    @stripe_card_token = params[:stripe_card_token]
    begin
      if current_user.update_stripe(@stripe_card_token)
        flash[:success] = "Your card has been updated"
        @invoice = current_user.current_invoice
        if @invoice.period_end_date < Time.now and @invoice.total_price_in_cents > 0
          @invoice.charge_customer(false)
        end
      end
    rescue Stripe::StripeError => e
      logger.error "StripeError: #{e.message}"
      flash[:error] = "There was a problem with your credit card"
      @stripe_card_token = nil
    rescue ActiveRecord::StaleObjectError => e
      # ERROR invoice is currently being charged.
      flash[:alert] = "Your invoice is currently being charged. You can't update your card at this time."
    end
    @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token) unless current_user.stripe_customer_token.blank?
    render :edit
  end
end
