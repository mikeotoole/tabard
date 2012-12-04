###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class CommunitiesController < ApplicationController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!, except: [:show, :index, :check_name]
  skip_before_filter :ensure_not_ssl_mode, only: [:new, :create, :destroy, :remove_confirmation]
  skip_before_filter :limit_subdomain_access, only: [:new, :create, :destroy, :remove_confirmation]
  before_filter :ensure_secure_subdomain, only: [:new, :create, :destroy, :remove_confirmation]
  load_and_authorize_resource except: [:create, :index, :check_name]
  before_filter :load_plans_and_stripe, only: [:new, :create]

###
# REST Actions
###
  # GET /communities/:id(.:format)
  def show
    redirect_to root_url(subdomain: @community.subdomain)
  end

  # GET /communities/new(.:format)
  def new
    @community.admin_profile = current_user.user_profile
  end

  # GET /communities/check_name(.:format)
  def check_name
    name = params[:name]
    testCommunity = Community.new name: name
    testCommunity.valid?
    errors = testCommunity.errors[:name]

    if errors.any?
      render json: {success: false, errors: errors}
    else
      render json: {success: true}
    end
  end

  # POST /communities(.:format)
  def create
    success = false
    @stripe_card_token = params[:stripe_card_token]
    @community = Community.new(params[:community])
    @community.admin_profile = current_user.user_profile
    authorize! :create, @community

    Community.transaction do
      begin
        invoice = current_user.current_invoice
        success = @community.save_with_plan(params[:plan_id], @stripe_card_token, invoice)
      rescue Stripe::StripeError => e
        @community.errors.add :base, "There was a problem with your credit card"
        @stripe_card_token = nil
        raise ActiveRecord::Rollback
      end
      raise ActiveRecord::Rollback unless success
    end

    flash[:success] = "Your community has been created." if success
    respond_with(@community, location: edit_community_settings_url(subdomain: @community.subdomain))
  end

  # DELETE /communities/:id(.:format)
  def destroy
    if params[:user] and current_user.valid_password?(params[:user][:current_password])
      Community.delay.destory_community(@community.id)
      @community.update_column(:pending_removal, true)
      flash[:notice] = 'Community is being removed.'
      redirect_to user_profile_url(current_user.user_profile, subdomain: "www", protocol: "http://")
    else
      flash[:alert] = 'Password was not valid.'
      redirect_to community_remove_confirmation_community_url(@community, subdomain: "secure", protocol: (Rails.env.development? ? "http://" : "https://"))
    end
  end

  # Removes confirmations
  def remove_confirmation
  end

protected

  # Loads all available plans.
  def load_plans_and_stripe
    @available_plans = CommunityPlan.available
    begin
      @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token) unless current_user.stripe_customer_token.blank?
    rescue
    ensure
      @stripe ||= nil
    end
  end

###
# Helper methods
###
  helper_method :sort_column
private
  def sort_column
    Community.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
end
