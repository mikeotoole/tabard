###
# This is a custom session controller used to add additional functionality to devise's session controller.
###
class SessionsController < Devise::SessionsController
  prepend_view_path "app/views/devise"

  skip_before_filter :block_unauthorized_user!
  skip_before_filter :check_force_logout, :only => [:create, :destroy]
  skip_before_filter :ensure_accepted_most_recent_legal_documents, :destroy, :limit_subdomain_access
  skip_before_filter :ensure_not_ssl_mode
  before_filter :ensure_secure_subdomain, :only => [:create]

  ###
  # The create is overrided to force the signing out of the admin user if needed.
  ###
  def create
    sign_out(current_admin_user) if current_admin_user
    current_user.update_attribute(:force_logout, false) if current_user and current_user.force_logout
    super
  end
end