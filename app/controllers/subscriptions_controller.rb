###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# Controller used to manage community subscriptions.
###
class SubscriptionsController < PaymentController
  respond_to :html, :js

###
# Callbacks
###
  skip_before_filter :ensure_not_ssl_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain
  before_filter :load_variables
  before_filter :load_community, only: [:edit, :update]

  # GET /subscriptions(.:format)
  def index
    @owned_communities = current_user.owned_communities
  end

  # GET /subscriptions/:community_id/edit(.:format)
  def edit
    # Get invoice item for current plan.
    @current_plan_invoice_item = @invoice.plan_invoice_item_for_community(@community)

    @all_upgrades_invoice_items = @invoice.recurring_upgrade_invoice_items_for_community(@community)
    if @all_upgrades_invoice_items.blank?
      @all_upgrades_invoice_items = @invoice.invoice_items.new({item: CommunityUpgrade.first, quantity: 0, community_id: @community.id}, without_protection: true)
    end
  end

  # PUT /subscriptions/:community_id
  def update
    @stripe_card_token = params[:stripe_card_token]
    begin
      if @invoice.update_attributes_with_payment(params[:invoice], @stripe_card_token)
        flash[:success] = "Your plan has been changed"
      else
        @current_plan_invoice_item = @invoice.invoice_items.select{|ii| ii.has_community_plan?}.first
        @all_upgrades_invoice_items = @invoice.invoice_items.recurring.select{|ii| ii.has_community_upgrade?}
        @invoice.invoice_items.each{|ii| puts ii.errors.full_messages}
      end
    rescue Stripe::StripeError => e
      @invoice.errors.add :base, "There was a problem with your credit card"
      @stripe_card_token = nil
    rescue ActiveRecord::StaleObjectError => e
      # ERROR invoice is currently being charged.
      flash[:alert] = "Your invoice is currently being charged."
      redirect_to subscriptions_path
      return true
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
  # Loads community used by edit and update.
  ###
  def load_community
    @community = current_user.owned_communities.find(params[:community_id])
     @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token) unless current_user.stripe_customer_token.blank?
    if @invoice.processing_payment
      flash[:notice] = "Your account is currently being processd and no changes can be made at this time."
      redirect_to subscriptions_url
    end
  end

  ###
  # _before_filter_
  #
  # Loads variables
  ###
  def load_variables
    @available_plans = CommunityPlan.available
    @invoice = current_user.current_invoice
  end
end
