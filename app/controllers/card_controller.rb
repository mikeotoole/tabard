###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# Controller used to edit card information
###
class CardController < ApplicationController
  respond_to :html, :js

###
# Callbacks
###
  skip_before_filter :ensure_not_ssl_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain

  def edit
    @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token)
  end

  def update
    @stripe_card_token = params[:stripe_card_token]
    begin
      if current_user.update_stripe(@stripe_card_token)
        flash[:success] = "Your card has been updated"
        # TODO add handing for delinquent accounts.
      end
    rescue Stripe::StripeError => e
      logger.error "StripeError: #{e.message}"
      flash[:error] = "There was a problem with your credit card"
      @stripe_card_token = nil
    end
    @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token)
    render :edit
  end
end
