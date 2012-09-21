###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# Controller used to manage community subscriptions.
###
class SubscriptionsController < ApplicationController
  respond_to :html, :js

###
# Callbacks
###
  skip_before_filter :ensure_not_ssl_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain
  before_filter :load_variables, only: [:edit, :update, :create]

  # GET /subscriptions(.:format)
  def index
    @owned_communities = current_user.owned_communities
  end

  # GET /subscriptions/:id/edit(.:format)
  def edit
    if @community.blank?
      raise CanCan::AccessDenied
    else
      @current_invoice = current_user.current_invoice
      if @current_invoice.blank?
        @current_invoice = current_user.invoices.new({period_start_date: Date.today}, without_protection: true) 
        @current_invoice.recurring_plan_invoice_item_for_community(@community)
      end
    end
  end
  def create
    current_user.invoices.create(params[:invoice])
    redirect_to edit_subscription_url(@community)
  end

  # PUT /subscriptions/:id(.:format)
  def update
    if @community.blank?
      raise CanCan::AccessDenied
    else
      @stripe_card_token = params[:stripe_card_token]
      if params[:community].blank?
        @community.errors.add :base, "You must pick a plan"
      else
        begin
          flash[:success] = "Your plan has been changed" if @community.update_attributes_with_payment(params[:community], @stripe_card_token)
        rescue Stripe::StripeError => e
          logger.error "StripeError: #{e.message}"
          @community.errors.add :base, "There was a problem with your credit card"
          @stripe_card_token = nil
        end
      end
      respond_with(@community, location: edit_subscription_url(@community))
    end
  end

###
# Protected Methods
###
protected

  ###
  # _before_filter_
  #
  # Loads variables used by edit and update.
  ###
  def load_variables
    @community = current_user.owned_communities.find_by_id(params[:id])
    @available_plans = CommunityPlan.available
  end
end
