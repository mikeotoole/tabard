###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Unlocks Controller
###
class UnlocksController < Devise::UnlocksController
  prepend_view_path "app/views/devise"

  protected

  # Override default path
  def after_sending_unlock_instructions_path_for(resource)
    root_url
  end
end