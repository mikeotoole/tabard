class SiteActionController < ApplicationController
  respond_to :html
###
# Callbacks
###
  skip_before_filter :authenticate_user!
  skip_before_filter :ensure_active_profile_is_valid
  skip_before_filter :fetch_crumblin_games

###
# Actions
###
  # This redirects all traffic to maintenance page.
  def toggle_maintenance_mode
    if can?(:toggle_maintenance_mode, SiteActionController)
      if maintenance_mode?
        stop_maintenance_mode
      else
        start_maintenance_mode
      end
      notice = (maintenance_mode? ? "Maintenance Mode On" : "Maintenance Mode Off")
      redirect_to previous_page, :notice => notice
    else
      redirect_to previous_page, :alert => "You are not authorized!"
    end      
  end
end