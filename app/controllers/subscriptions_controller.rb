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
  before_filter :load_variables, only: [:edit, :update]

  # GET /subscriptions(.:format)
  def index
    @owned_communities = current_user.owned_communities
  end

  # GET /subscriptions/:community_id/edit(.:format)
  def edit
    if @community.blank?
      raise CanCan::AccessDenied
    else
      @current_invoice = current_user.current_invoice
      # Get invoice item for current plan.
      @current_plan_invoice_item = @current_invoice.recurring_plan_invoice_item_for_community(@community)

      current_plan = @current_plan_invoice_item.item

      existing_upgrades_invoice_items = @current_invoice.recurring_upgrade_invoice_items_for_community(@community)

      existing_upgrades = existing_upgrades_invoice_items.map{|i| i.item}
      new_upgrades = current_plan.community_upgrades.delete_if{|plan| existing_upgrades.include?(plan) }
      new_upgrades_invoice_items = new_upgrades.map{ |item| @current_invoice.invoice_items.new({item: item, quantity: 0, community_id: @community.id}, without_protection: true)}

      @all_upgrades_invoice_items = existing_upgrades_invoice_items + new_upgrades_invoice_items
    end
  end

  # PUT /subscriptions/:community_id
  def update
    @invoice = current_user.current_invoice
    @stripe_card_token = params[:stripe_card_token]
    begin
      if @invoice.update_attributes_with_payment(params[:invoice], @stripe_card_token)
        flash[:success] = "Your plan has been changed"
      end
    rescue Stripe::StripeError => e
      logger.error "StripeError: #{e.message}"
      @invoice.errors.add :base, "There was a problem with your credit card"
      @stripe_card_token = nil
    end
    respond_with(@invoice, location: edit_subscription_url(@community))
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
    @community = current_user.owned_communities.find_by_id(params[:community_id])
    @available_plans = CommunityPlan.available
  end
end
