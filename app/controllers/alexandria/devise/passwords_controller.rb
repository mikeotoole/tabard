###
# This is a custom session controller used to force custom view for active admin devise's session controller.
###
class Alexandria::Devise::PasswordsController < ActiveAdmin::Devise::PasswordsController
  prepend_view_path "app/views/devise"
  skip_before_filter :check_maintenance_mode
  skip_before_filter :block_unauthorized_user!, except: [:new, :create]
  layout 'application'
end

# Scoped to admin panel
module Admin
end

# Scoped to devise
module Admin::Devise
end
