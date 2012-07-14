###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is used by the admin portal for site wide actions.
###
class SiteConfigurationController < ApplicationController
  respond_to :html
###
# Callbacks
###
  skip_before_filter :block_unauthorized_user!
  skip_before_filter :fetch_top_level_games
  skip_before_filter :check_maintenance_mode

###
# Actions
###

  ###
  # This redirects all traffic to maintenance page.
  # POST /toggle_maintenance_mode(.:format)
  ###
  def toggle_maintenance_mode
    if can?(:toggle_maintenance_mode, SiteConfigurationController)
      if SiteConfiguration.is_maintenance?
        SiteConfiguration.current_configuration.update_attribute(:is_maintenance, false)
      else
        SiteConfiguration.current_configuration.update_attribute(:is_maintenance, true)
      end
      notice = (SiteConfiguration.is_maintenance? ? "Maintenance Mode ON" : "Maintenance Mode OFF")
      redirect_to admin_dashboard_url, notice: notice
    else
      redirect_to admin_dashboard_url, alert: "You are not authorized!"
    end
  end
end
