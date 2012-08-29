class SubscriptionsController < ApplicationController
  respond_to :html, :js
  skip_before_filter :ensure_not_ssl_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain
  before_filter :load_variables, only: [:edit, :update]

  def index
    @owned_communities = current_user.owned_communities
  end

  def edit
    if @community.blank?
      redirect_to forbidden_url
    end
    @community.community_plan.community_upgrades.each do |upgrade|
      @community.current_community_upgrades.new(community_upgrade_id: upgrade.id, number_in_use: 0) unless @community.community_upgrades.include?(upgrade)
    end
  end

  def update
    if @community.blank? or params[:community].blank?
      redirect_to forbidden_url
    else
      @stripe_card_token = params[:stripe_card_token]
      add_new_flash_message("Your plan has been changed",'success') if @community.update_with_payment(params[:community], @stripe_card_token)
      respond_with(@community, location: edit_subscription_url(@community))
    end
  end

  def load_variables
    @community = current_user.owned_communities.find_by_id(params[:id])
    @available_plans = CommunityPlan.available
  end
end
