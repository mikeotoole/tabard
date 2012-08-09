###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Registrations Controller
###
class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"

  skip_before_filter :block_unauthorized_user!, only: [:create, :new]
  skip_before_filter :ensure_accepted_most_recent_legal_documents, :limit_subdomain_access
  skip_before_filter :ensure_not_ssl_mode, only: [:create, :update, :new, :edit, :disable_confirmation, :destroy]
  before_filter :ensure_secure_subdomain, only: [:create, :update, :new, :edit, :disable_confirmation, :destroy]
  before_filter :block_unauthorized_user!, only: [:cancel_confirmation]
  before_filter :hide_the_announcements, only: [:new, :edit, :update]

###
# Sign Up
###
  # Overriding Devise method to add a flash if the user is signing up from a community.
  def new
    community = Community.find_by_id(params[:community_id])
    add_new_flash_message "Before you can apply to #{community.name} you need to create a Guild.io&trade; account or login.", "notice" if community
    add_new_flash_message "This version of Guild.io&trade; is a Beta Test. ALL DATA WILL BE REMOVED at the end of the test.", "alert" if User::BETA_CODE_REQUIRED
    super
  end

  # Overriding Devise method to redirect to reinstate_confirmation_url if email belongs to a user disabled account.
  def create
    user = User.find_by_email(params[:user][:email]) if params[:user] and params[:user][:email]
    if user and user.user_disabled_at
      add_new_flash_message "You need to reactivate your account.", "alert"
      redirect_to reinstate_confirmation_url
    elsif !!params[:user][:is_partial_request]
      build_resource
      resource.save
      add_new_flash_message "Great! We need a little more information before your account can be created.", "notice"
      resource.errors.clear
      #clean_up_passwords resource
      render :new
    else
      super
    end
  end

###
# Disabling Account
###
  # GET /users/disable_confirmation
  def disable_confirmation
    @user = current_user
    @hide_announcements = true
    if not @user
      set_flash_message :alert, :not_signed_id
      redirect_to new_user_session_url(subdomain: 'secure', protocol: "https://")
    end
  end

  # Disable a user's account
  def destroy
    success = resource ? resource.disable_by_user(params) : false
    if success
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      add_new_flash_message "Your account has been deactivated.", "notice"
      redirect_to root_url_hack_helper(root_url(protocol: "http://", subdomain: false))
    else
      @hide_announcements = true
      render 'disable_confirmation'
    end
  end

###
# Reinstating Account
###
  # GET /users/reinstate
  def reinstate_confirmation
    @user = User.new
  end

  # PUT /users/reinstate
  def send_reinstate
    user = User.find_by_email(params[:user][:email]) if params[:user]
    success = user ? user.reinstate_by_user : false
    add_new_flash_message "If a deactivated account with that address exists, you will receive an email with reactivation instructions in a few minutes.", "notice"
    redirect_to root_url
  end

  # GET /users/reinstate_account?reset_password_token=abcdef
  def reinstate_account_edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render :reinstate_account
  end

  # PUT /users/reinstate_account
  def reinstate_account    
    self.resource = User.find_or_initialize_with_error_by(:reset_password_token, params[resource_name][:reset_password_token])
    if resource.reset_password_period_valid?

      resource.password = params[resource_name][:password]
      resource.password_confirmation = params[resource_name][:password_confirmation]
      resource.valid?

      if params[resource_name][:accepted_current_terms_of_service] == "1"
        resource.accepted_current_terms_of_service = true
      else
        resource.errors.add(:accepted_current_terms_of_service, "must be accepted")
      end
      
      if params[resource_name][:accepted_current_privacy_policy] == "1"
        resource.accepted_current_privacy_policy = true
      else
        resource.errors.add(:accepted_current_privacy_policy, "must be accepted")
      end
    else
      add_new_flash_message 'Account reactivation token has expired, please request a new one.', 'alert'
      resource.errors.add(:base, "Account reactivation token has expired, please request a new one")
    end

    if resource.errors.empty?
      resource.user_disabled_at = nil
      resource.reset_password_token = nil
      resource.reset_password_sent_at = nil
      resource.save!
      add_new_flash_message "Your account has been reactivated. Welcome back to Guild.io&trade;!", "success"
      sign_in(resource_name, resource)
      redirect_to after_sign_in_path_for(resource)
    else
      render :reinstate_account, resource: resource
    end
  end

###
# URLs
###
  # Where to redirect to after signing up with devise
  def after_sign_up_path_for(resource)
    root_url_hack_helper(root_url(protocol: "http://", subdomain: false))
  end

  # Where to redirect to after signing up with devise, and the account is inactive.
  def after_inactive_sign_up_path_for(resource)
    root_url_hack_helper(root_url(protocol: "http://", subdomain: false))
  end

  # Where to redirect to after updating the account with devise
  def after_update_path_for(resource)
    edit_user_registration_url(subdomain: "secure", protocol: (Rails.env.development? ? "http://" : "https://"))
  end

  # Hides the announcements.
  def hide_the_announcements
    @hide_announcements = true
  end
end
