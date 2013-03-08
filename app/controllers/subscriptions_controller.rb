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

    # Get all upgrades for the current community.
    @all_upgrades_invoice_items = @invoice.recurring_upgrade_invoice_items_for_community(@community)

    # TODO This should check that there exists a upgrade for all available upgrades for the current plan.
    if @all_upgrades_invoice_items.blank?
      # TODO For each missing upgrade add a zero quantity one (so the user can add upgrades).
      @all_upgrades_invoice_items = @invoice.invoice_items.new({item: CommunityUpgrade.first, quantity: 0, community_id: @community.id}, without_protection: true)
    end

    flash[:success] = "To upgrade to a Pro community, add or update your card on file click 'Update Subscription'." if params[:upgrade] == 'true'
    flash[:notice] = "Your #{@community.current_community_plan.title} subscription will be active until #{@invoice.period_end_date.strftime('%B %d, %Y')}." if @invoice.is_downgrading?(@community)
  end

  # PUT /subscriptions/:community_id
  def update
    @stripe_card_token = params[:stripe_card_token]
    begin
      success_message = "Your plan has been changed"
      # Check to see if the community is charge exempt..
      if @community.is_charge_exempt
        #.. If it is just update it.
        if @invoice.update_attributes(params[:invoice])
          flash.now[:success] = success_message
        else
          flash.now[:error] = "We were unable to update your account at this time."
        end
      #.. If it is not exempt, try to update it with payment..
      elsif @invoice.update_attributes_with_payment(params[:invoice], @stripe_card_token)
        flash.now[:success] = success_message
      #.. If it can't be updated with payment, then set the view variables from the current invoice.
      else

        @current_plan_invoice_item = @invoice.invoice_items.select{|ii| ii.has_community_plan?}.first
        @all_upgrades_invoice_items = @invoice.invoice_items.recurring.select{|ii| ii.has_community_upgrade?}
      end
    # Rescue from Stripe errors and let the user know what is happening.
    rescue Stripe::StripeError => e
      @invoice.errors.add :base, "There was a problem with your credit card"
      @stripe_card_token = nil
    # Rescue from stale objects (Locked) and let the user know what is happening.
    rescue ActiveRecord::StaleObjectError => e
      # ERROR invoice is currently being charged.
      flash.now[:alert] = "Your invoice is currently being charged."
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
  # Loads variables
  ###
  def load_variables
    @available_plans = CommunityPlan.available
    @invoice = current_user.current_invoice
  end

  ###
  # _before_filter_
  #
  # Loads community used by edit and update.
  ###
  def load_community
    @community = current_user.owned_communities.find(params[:community_id])
    begin
      @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token) unless current_user.stripe_customer_token.blank?
    rescue
    ensure
      @stripe ||= nil
    end
    if @invoice.processing_payment
      flash[:notice] = "Your account is currently being processd and no changes can be made at this time."
      redirect_to subscriptions_url
    end
  end
end
