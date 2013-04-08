###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Unlocks Controller
###
class UnlocksController < Devise::UnlocksController
  prepend_view_path "app/views/devise"
  skip_before_filter :block_unauthorized_user!
  after_filter :change_notices_to_successes, only: [:create]

  protected

  # Override default path
  def after_sending_unlock_instructions_path_for(resource)
    root_url
  end

  def after_unlock_path_for(resource)
    new_session_url(resource)
  end
end
