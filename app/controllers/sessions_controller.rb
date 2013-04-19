###
# This is a custom session controller used to add additional functionality to devise's session controller.
###
class SessionsController < Devise::SessionsController
  prepend_view_path "app/views/devise"

  skip_before_filter :block_unauthorized_user!
  skip_before_filter :check_force_logout, only: [:create, :destroy]
  skip_before_filter :ensure_accepted_most_recent_legal_documents
  skip_after_filter :store_location
  before_filter :sign_out_admin_user, only: :create
  after_filter :change_notices_to_successes, only: [:create]

  # Overriding new to hide announcements
  def new
    super
  end

  ###
  # The create is overrided to force the signing out of the admin user if needed.
  ###
  def create
    current_user.update_column(:force_logout, false) if current_user and current_user.force_logout
    resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#new")
    after_sign_in_path = after_sign_in_path_for(resource)
    flash[:notice] = "This version of Tabard is a Beta Test. ALL DATA WILL BE REMOVED at the end of the test." if User::BETA_CODE_REQUIRED
    respond_with resource, location: after_sign_in_path.match(/\.js$/) ? root_url : after_sign_in_path
  end
end
