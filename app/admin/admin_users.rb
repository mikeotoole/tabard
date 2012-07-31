ActiveAdmin.register AdminUser do
  menu parent: "User", priority: 11, if: proc{ can?(:read, AdminUser) }
  controller.authorize_resource except: [:edit_account, :update_account]

  action_item only: :show do
    if can? :reset_password, admin_user
      link_to "Reset Password", reset_password_admin_admin_user_path(admin_user), method: :put, data: { confirm: 'Are you sure you want to reset user password?' }
    end
  end

  action_item only: :index do
    if can? :reset_all_passwords, AdminUser.new
      link_to "Reset All Passwords", reset_all_passwords_admin_admin_users_path, method: :post, data: { confirm: 'Are you sure you want to reset ALL admin user passwords?' }
    end
  end

  member_action :reset_password, method: :put do
    admin_user = AdminUser.find(params[:id])
    admin_user.reset_password
    redirect_to action: :show
  end

  collection_action :edit_account, method: :get do
    authorize!(:edit_account, current_admin_user)
    @admin_user = current_admin_user
  end

  collection_action :update_account, method: :put do
    authorize!(:update_account, current_admin_user)
    params[:admin_user].delete(:role)
    if current_admin_user.update_with_password(params[:admin_user])
      sign_in(current_admin_user, bypass: true)
      flash[:notice] = 'Account updated.'
      redirect_to admin_dashboard_url
    else
      @admin_user = current_admin_user
      render action: :edit_account
    end
  end

  collection_action :reset_all_passwords, method: :post do
    AdminUser.delay.reset_all_passwords
    flash[:message] = "Password resets in progress."
    redirect_to action: :index
  end

  filter :id
  filter :email
  filter :current_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_at
  filter :last_sign_in_ip
  filter :created_at

  index do
    column "View" do |admin_user|
      link_to "View", admin_admin_user_path(admin_user)
    end
    column :display_name
    column :email
    column :role
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :created_at
    column "Destroy" do |admin_user|
      if can? :destroy, admin_user
        link_to "Destroy", [:admin, admin_user], method: :delete, data: { confirm: 'Are you sure you want to delete this user?' }
      end
    end
  end

  show title: :email do
    rows = default_attribute_table_rows.delete_if { |att| [:encrypted_password, :reset_password_token, :confirmation_token, :unlock_token].include?(att) }
    attributes_table *rows
    active_admin_comments
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :display_name, hint: "This is what end users will see you as."
      f.input :email
      f.input :avatar, as: :file
      f.input :role, as: :select, collection: AdminUser::ROLES
    end
    f.buttons
  end
end
