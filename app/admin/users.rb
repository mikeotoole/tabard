ActiveAdmin.register User do
  menu parent: "User", priority: 1, if: proc{ can?(:read, User) }
  controller.authorize_resource

  actions :index, :show

  action_item only: :show do
    if not user.admin_disabled_at and can? :disable, user
      link_to "Disable User", disable_alexandria_user_path(user), method: :put, :data => { :confirm => 'Are you sure you want to deactivate this user?' }
    end
  end

  action_item only: :show do
    if (user.admin_disabled_at or user.user_disabled_at) and can? :reinstate, user
      link_to "Reactivate User", reinstate_alexandria_user_path(user), method: :put, :data => { :confirm => 'Are you sure you want to reactivate this user?' }
    end
  end

  action_item only: :show do
    if can? :reset_password, user
      link_to "Reset Password", reset_password_alexandria_user_path(user), method: :put, :data => { :confirm => 'Are you sure you want to reset user password?' }
    end
  end

  action_item only: :show do
    if can? :nuke, user
      link_to "Nuke User", nuke_alexandria_user_path(user), method: :delete, :data => { :confirm => 'Are you sure you want to NUKE User?' }
    end
  end

  action_item only: :index do
    if can? :reset_all_passwords, User.new
      link_to "Reset All Passwords", reset_all_passwords_alexandria_users_path, method: :post, :data => { :confirm => 'Are you sure you want to reset ALL user passwords?' }
    end
  end

  member_action :disable, method: :put do
    user = User.find(params[:id])
    user.disable_by_admin if user
    flash.now[:message] = "User deactivated."
    redirect_to action: :show
  end

  member_action :nuke, method: :delete do
    user = User.find(params[:id])
    User.delay.nuke_user(user.id)
    flash.now[:message] = "User is being nuked."
    redirect_to action: :index
  end

  member_action :reinstate, method: :put do
    user = User.find(params[:id])
    user.reinstate_by_admin if user
    flash.now[:notice] = "User reactivated."
    redirect_to action: :show
  end

  member_action :reset_password, method: :put do
    user = User.find(params[:id])
    user.reset_password if user
    redirect_to action: :show
  end

  collection_action :reset_all_passwords, method: :post do
    User.delay.reset_all_passwords
    flash.now[:message] = "Password resets in progress."
    redirect_to action: :index
  end

  collection_action :sign_out_all_users, method: :post do
    User.force_active_users_to_sign_out
    flash.now[:notice] = "All Users Signed out."
    redirect_to alexandria_dashboard_url
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
      link_to "View", alexandria_user_path(user)
    end
    column do |au|
      image_tag(au.avatar_url(:small), class: 'avatar')
    end
    column :email
    column "User Profile" do |user|
      link_to user.display_name, [:alexandria, user.user_profile]
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

    #active_admin_comments
  end
end
