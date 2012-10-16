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
  before_filter :block_unauthorized_user!, except: [:show, :index]
  skip_before_filter :ensure_not_ssl_mode, only: [:destroy]
  skip_before_filter :limit_subdomain_access, only: [:destroy]
  before_filter :ensure_secure_subdomain, only: [:destroy]
  load_and_authorize_resource except: [:create, :index]
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

  # POST /communities(.:format)
  def create
    success = false
    @stripe_card_token = params[:stripe_card_token]
    @community = Community.new(params[:community])
    @community.admin_profile = current_user.user_profile
    authorize! :create, @community

    plan = CommunityPlan.available.find_by_id(params[:plan_id])
    success = @community.save
    if success and plan.present? and not plan.is_free_plan?
      begin
        invoice = current_user.current_invoice
        invoice.invoice_items.new({community: @community, item: plan, quantity: 1}, without_protection: true)
        unless invoice.update_attributes_with_payment(nil, @stripe_card_token)
          # TODO: Need to delete community and add error.
        end
      rescue Stripe::StripeError => e
        # TODO: Need to delete community and add error.
        @community.errors.add :base, "There was a problem with your credit card"
        @stripe_card_token = nil
      end
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
      redirect_to user_profile_url(current_user.user_profile, subdomain: false, protocol: "http://")
    else
      flash[:alert] = 'Password was not valid.'
      redirect_to community_remove_confirmation_url(subdomain: @community.subdomain)
    end
  end

protected

  # Loads all available plans.
  def load_plans_and_stripe
    @available_plans = CommunityPlan.available
    @stripe = Stripe::Customer.retrieve(current_user.stripe_customer_token) unless current_user.stripe_customer_token.blank?
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
