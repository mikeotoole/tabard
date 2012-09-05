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

  # GET /subscriptions/:id/edit(.:format)
  def edit
    if @community.blank?
      redirect_to forbidden_url
    end
    @community.community_plan.community_upgrades.each do |upgrade|
      @community.current_community_upgrades.new(community_upgrade_id: upgrade.id, number_in_use: 0) unless @community.community_upgrades.include?(upgrade)
    end
  end

  # PUT /subscriptions/:id(.:format)
  def update
    if @community.blank? or params[:community].blank?
      redirect_to forbidden_url
    else
      @stripe_card_token = params[:stripe_card_token]

      begin
        add_new_flash_message("Your plan has been changed",'success') if @community.update_attributes_with_payment(params[:community], @stripe_card_token)
      rescue Stripe::StripeError => e
        logger.error "StripeError: #{e.message}"
        @community.errors.add :base, "There was a problem with your credit card"
        @stripe_card_token = nil
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
