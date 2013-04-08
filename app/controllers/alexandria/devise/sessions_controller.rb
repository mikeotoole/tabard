###
# This is a custom session controller used to force custom view for active admin devise's session controller.
###
class Alexandria::Devise::SessionsController < ActiveAdmin::Devise::SessionsController
  skip_before_filter :block_unauthorized_user!
  skip_before_filter :check_maintenance_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain, only: [:new,:create]
  after_filter :validation_code_correct, only: :create
  layout 'application'

  # GET /admin/login
  def new
    super
  end

  def create
    super
  end

  def validation_code_correct
    if Rails.env.development? or Rails.env.test? or params[:admin_user][:validation_code] == ROTP::TOTP.new(current_admin_user.auth_secret).now.to_s
      return true
    else
      current_admin_user.errors.add(:validation_code, "Invalid Code")
      sign_out current_admin_user if current_admin_user
      return true
    end
  end
end

# Scoped to admin panel
module Admin
end

# Scoped to devise
module Admin::Devise
end
