###
# This is a custom session controller used to add additional functionality to devise's session controller.
###
class SessionsController < Devise::SessionsController
  skip_before_filter :check_force_logout, :only => [:create, :destroy]

  ###
  # The create is overrided to force the signing out of the admin user if needed.
  ###
  def create
    sign_out(current_admin_user) if current_admin_user
    current_user.update_attribute(:force_logout, false) if current_user.force_logout
    super
  end
end