###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# Controller used to edit card information
###
class CardController < PaymentController
  respond_to :html, :js

  # GET /card
  def edit
    begin
      @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token) unless current_user.stripe_customer_token.blank?
    rescue
    ensure
      @stripe ||= nil
    end
    @invoice = current_user.current_invoice
    # Set invoice to nil if the invoice is not delinquent.
    @invoice = nil unless @invoice.persisted? and (@invoice.period_end_date < Time.now and @invoice.total_price_in_cents > 0)
  end

  # PUT /card
  def update
    @stripe_card_token = params[:stripe_card_token]
    begin
      if current_user.update_stripe(@stripe_card_token)
        flash.now[:success] = "Your card has been updated"
        @invoice = current_user.current_invoice
        if @invoice.persisted? and @invoice.period_end_date < Time.now and @invoice.total_price_in_cents > 0
          @invoice.charge_customer(false)
        else
          @invoice = nil
        end
      else
        self.errors.add :base, "There was a problem with your credit card. Insure your full billing address is provided."
      end
    rescue Stripe::StripeError => e
      flash.now[:error] = "#{e.message}"
      @stripe_card_token = nil
    rescue ActiveRecord::StaleObjectError => e
      # ERROR invoice is currently being charged.
      flash.now[:alert] = "Your invoice is currently being charged."
    end
    begin
      @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token) unless current_user.stripe_customer_token.blank?
    rescue
    ensure
      @stripe ||= nil
    end
    render :edit
  end
end
