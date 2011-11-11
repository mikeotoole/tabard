class SiteActionController < ApplicationController
  respond_to :html
###
# Callbacks
###
  skip_before_filter :authenticate_user!
  skip_before_filter :ensure_active_profile_is_valid
  skip_before_filter :fetch_crumblin_games
  skip_before_filter :check_maintenance_mode

###
# Actions
###
  ###
  # This redirects all traffic to maintenance page.
  # PUT /toggle_maintenance_mode(.:format)
  ###
  def toggle_maintenance_mode
    if can?(:toggle_maintenance_mode, SiteActionController)
      if maintenance_mode?
        $maintenance_mode = false
      else
        $maintenance_mode = true
      end
      notice = (maintenance_mode? ? "Maintenance Mode ON" : "Maintenance Mode OFF")
      redirect_to admin_dashboard_url, :notice => notice
    else
      redirect_to admin_dashboard_url, :alert => "You are not authorized!"
    end      
  end
end