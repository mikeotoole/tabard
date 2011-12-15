###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Registrations Controller
###
class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"

  skip_before_filter :block_unauthorized_user!, :only => [:create, :new]
  skip_before_filter :limit_subdomain_access
  skip_before_filter :ensure_not_ssl_mode, :only => [:create, :update]
  before_filter :ensure_secure_subdomain, :only => [:create, :update]
  before_filter :block_unauthorized_user!, :only => [:cancel_confirmation]

  def create
    user = User.find_by_email(params[:user][:email]) if params[:user] and params[:user][:email]
    if user and user.user_disabled_at
      add_new_flash_message("You need to reenable account.")
    else
      super
    end
  end

  # Cancels a user's account
  def destroy
    success = resource ? resource.disable_by_user(params) : false
    if success
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      add_new_flash_message("Your account has be canceled.", 'notice')
      respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    else
      render 'cancel_confirmation'
    end
  end

  # GET /users/cancel_confirmation
  def cancel_confirmation
    @user = current_user
    if not @user
      set_flash_message :alert, :not_signed_id
      redirect_to new_user_session_url
    end
  end

  # Where to redirect to after signing up with devise
  def after_sign_up_path_for(resource)
    root_url_hack_helper(root_url(:protocol => "http://", :subdomain => false))
  end

  # Where to redirect to after signing up with devise, and the account is inactive.
  def after_inactive_sign_up_path_for(resource)
    root_url_hack_helper(root_url(:protocol => "http://", :subdomain => false))
  end

  # Where to redirect to after updating the account with devise
  def after_update_path_for(resource)
    root_url_hack_helper(edit_user_registration_url(:protocol => "http://", :subdomain => false))
  end
end
