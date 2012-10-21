###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Confirmations Controller
###
class ConfirmationsController < Devise::ConfirmationsController
  prepend_view_path "app/views/devise"

  protected

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if resource.is_a?(User)
      user_profile_url(resource.user_profile)+"#characters"
    else
      after_sign_in_path_for(resource)
    end
  end

  # Override default path
  def after_resending_confirmation_instructions_path_for(resource_name)
    root_url
  end
end
