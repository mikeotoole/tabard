###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Registrations Controller
###
class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"

  skip_before_filter :block_unauthorized_user!, :only => [:create, :new, :cancel_confirmation]
  skip_before_filter :limit_subdomain_access
  skip_before_filter :ensure_not_ssl_mode, :only => [:create, :update]
  before_filter :ensure_secure_subdomain, :only => [:create, :update]

  # Cancels a user's account
  def destroy
    success = resource ? resource.disable_by_user(params) : false
    if success
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :notice, :destroyed if is_navigational_format?
      respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    else
      render 'cancel_confirmation'  
    end  
  end
  
  def cancel_confirmation
    @user = current_user
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
