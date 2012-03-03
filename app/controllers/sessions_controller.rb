###
# This is a custom session controller used to add additional functionality to devise's session controller.
###
class SessionsController < Devise::SessionsController
  prepend_view_path "app/views/devise"

  skip_before_filter :block_unauthorized_user!
  skip_before_filter :check_force_logout, :only => [:create, :destroy]
  skip_before_filter :ensure_accepted_most_recent_legal_documents, :limit_subdomain_access
  skip_before_filter :ensure_not_ssl_mode
  before_filter :ensure_secure_subdomain, :only => [:new, :create]

  # Overriding new to hide announcements
  def new
    @hide_announcements = true
    super
  end
  ###
  # The create is overrided to force the signing out of the admin user if needed.
  ###
  def create
    sign_out(current_admin_user) if current_admin_user
    current_user.update_attribute(:force_logout, false) if current_user and current_user.force_logout
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :user_signed_in, :display_name => current_user.display_name) if is_navigational_format?
    add_new_flash_message flash[:notice], 'success'
    flash.delete :notice
    session[:hide_announcements] = true
    after_sign_in_path = after_sign_in_path_for(resource)
    respond_with resource, :location => after_sign_in_path.match(/\.js$/) ? root_url : after_sign_in_path
  end
end