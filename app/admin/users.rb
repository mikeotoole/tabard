ActiveAdmin.register User do
  menu parent: "User", priority: 1, if: proc{ can?(:read, User) }
  controller.authorize_resource

  actions :index, :show

  action_item only: :show do
    if not user.admin_disabled_at and can? :disable, user
      link_to "Disable User", disable_admin_user_path(user), method: :put, confirm: 'Are you sure you want to disable this user?'
    end
  end

  action_item only: :show do
    if (user.admin_disabled_at or user.user_disabled_at) and can? :reinstate, user
      link_to "Reinstate User", reinstate_admin_user_path(user), method: :put, confirm: 'Are you sure you want to reinstate this user?'
    end
  end

  action_item only: :show do
    if can? :reset_password, user
      link_to "Reset Password", reset_password_admin_user_path(user), method: :put, confirm: 'Are you sure you want to reset user password?'
    end
  end

  action_item only: :show do
    if can? :nuke, user
      link_to "Nuke User", nuke_admin_user_path(user), method: :delete, confirm: 'Are you sure you want to NUKE User?'
    end
  end

  action_item only: :index do
    if can? :reset_all_passwords, User.new
      link_to "Reset All Passwords", reset_all_passwords_admin_users_path, method: :post, confirm: 'Are you sure you want to reset ALL user passwords?'
    end
  end

  member_action :disable, method: :put do
    user = User.find(params[:id])
    user.disable_by_admin if user
    flash[:message] = "User disabled."
    redirect_to action: :show
  end

  member_action :nuke, method: :delete do
    user = User.find(params[:id])
    User.delay.nuke_user(user.id)
    flash[:message] = "User is being nuked."
    redirect_to action: :index
  end

  member_action :reinstate, method: :put do
    user = User.find(params[:id])
    user.reinstate_by_admin if user
    flash[:notice] = "User reinstated."
    redirect_to action: :show
  end

  member_action :reset_password, method: :put do
    user = User.find(params[:id])
    user.reset_password if user
    redirect_to action: :show
  end

  collection_action :reset_all_passwords, method: :post do
    User.delay.reset_all_passwords
    flash[:message] = "Password resets in progress."
    redirect_to action: :index
  end

  collection_action :sign_out_all_users, method: :post do
    User.force_active_users_to_sign_out
    flash[:notice] = "All Users Signed out."
    redirect_to admin_dashboard_url
  end

  filter :id
  filter :email
  filter :name
  filter :sign_in_count
  filter :confirmation_sent_at
  filter :failed_attempts
  filter :created_at
  filter :admin_disabled_at
  filter :user_disabled_at
  filter :accepted_current_terms_of_service, as: :select
  filter :accepted_current_privacy_policy, as: :select

  index do
    column "View" do |user|
      link_to "View", admin_user_path(user)
    end
    column :email
    column "User Profile" do |user|
      link_to user.display_name, [:admin, user.user_profile]
    end
    column :failed_attempts
    column :locked_at
    column :disabled do |user|
      user.is_disabled? ? "Yes" : "No"
    end
    column :created_at
  end

  show title: :email do
    rows = default_attribute_table_rows.delete_if { |att| [:encrypted_password, :reset_password_token, :confirmation_token, :unlock_token].include?(att) }
    rows.insert(2, :user_profile)
    attributes_table *rows

    active_admin_comments
  end
end
