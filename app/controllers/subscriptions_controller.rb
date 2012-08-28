class SubscriptionsController < ApplicationController
  skip_before_filter :ensure_not_ssl_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain
  before_filter :load_variables, only: [:edit, :update]

  def index
    @owned_communities = current_user.owned_communities
    @user = current_user
  end

  def edit
    if @community.blank?
      redirect_to forbidden_url
    end
  end

  def update
    if @community.blank? or params[:community].blank?
      redirect_to forbidden_url
    else
      @plan = CommunityPlan.available.find_by_id(params[:community][:community_plan_id])
      @community.community_plan = @plan
      @community.save!
      render :index
    end
  end

  def load_variables
    @community = current_user.owned_communities.find_by_id(params[:id])
    @available_plans = CommunityPlan.available
  end
end
