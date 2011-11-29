###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Registrations Controller
###
class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"

  skip_before_filter :ensure_not_ssl_mode, :limit_subdomain_access
  before_filter :ensure_secure_subdomain

  # Cancels a user's account
  def destroy
    #TODO - We need to decide what we want to do here
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
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
    root_url_hack_helper(root_url(:protocol => "http://", :subdomain => false))
  end
end
