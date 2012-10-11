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
    # Get invoice item for current plan.
    @current_plan_invoice_item = @invoice.plan_invoice_item_for_community(@community)

    current_plan = @current_plan_invoice_item.item
    existing_upgrades_invoice_items = @invoice.recurring_upgrade_invoice_items_for_community(@community)
    existing_upgrades = existing_upgrades_invoice_items.map{|ii| ii.item}
    new_upgrades = CommunityUpgrade.all.delete_if{|upgrade| existing_upgrades.include?(upgrade) }
    new_upgrades_invoice_items = new_upgrades.map{ |item| @invoice.invoice_items.new({item: item, quantity: 0, community_id: @community.id}, without_protection: true)}

    @all_upgrades_invoice_items = existing_upgrades_invoice_items + new_upgrades_invoice_items
  end

  # PUT /subscriptions/:community_id
  def update
    @stripe_card_token = params[:stripe_card_token]
    begin
      if @invoice.update_attributes_with_payment(params[:invoice], @stripe_card_token)
        flash[:success] = "Your plan has been changed"
      else
        @current_plan_invoice_item = @invoice.invoice_items.select(&:has_community_plan?).first
        @all_upgrades_invoice_items = @invoice.invoice_items.select(&:has_community_upgrade?)
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
    @community = current_user.owned_communities.find(params[:community_id])
    @available_plans = CommunityPlan.available
    @invoice = current_user.current_invoice
  end
end
