###
# This is a custom session controller used to add additional functionality to devise's session controller.
###
class SessionsController < Devise::SessionsController
  ###
  # The create is overrided to force the signing out of the admin user if needed.
  ###
  def create
    sign_out(current_admin_user) if current_admin_user
    super
  end
end