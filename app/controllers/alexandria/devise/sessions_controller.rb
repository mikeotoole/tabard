###
# This is a custom session controller used to force custom view for active admin devise's session controller.
###
class Alexandria::Devise::SessionsController < ActiveAdmin::Devise::SessionsController
  skip_before_filter :block_unauthorized_user!
  skip_before_filter :check_maintenance_mode
  skip_before_filter :ensure_not_ssl_mode, :limit_subdomain_access
  before_filter :ensure_secure_subdomain, only: [:new,:create]
  layout 'application'

  # GET /admin/login
  def new
    super
  end
end

# Scoped to admin panel
module Admin
end

# Scoped to devise
module Admin::Devise
end
