ActiveAdmin.register User do
  menu :parent => "User", :priority => 1, :if => proc{ can?(:read, User) }
  controller.authorize_resource

  actions :index, :show, :destroy

  action_item :only => :show do
    if !user.suspended and can? :suspend, user
      link_to "Suspend User", suspend_admin_user_path(user), :method => :put, :confirm => 'Are you sure you want to suspend this user?'
    end
  end

  action_item :only => :show do
    if user.suspended and can? :reinstate, user
      link_to "Reinstate User", reinstate_admin_user_path(user), :method => :put, :confirm => 'Are you sure you want to reinstate this user?'
    end
  end

  action_item :only => :show do
    if can? :reset_password, user
      link_to "Reset Password", reset_password_admin_user_path(user), :method => :put, :confirm => 'Are you sure you want to reset user password?'
    end
  end

  action_item :only => :index do
    if can? :reset_all_passwords, User.new
      link_to "Reset All Passwords", reset_all_passwords_admin_users_path, :method => :post, :confirm => 'Are you sure you want to reset ALL user passwords?'
    end
  end

  member_action :suspend, :method => :put do
    user = User.find(params[:id])
    user.suspended = true
    user.save
    redirect_to :action => :show
  end

  member_action :reinstate, :method => :put do
    user = User.find(params[:id])
    user.suspended = false
    user.save
    redirect_to :action => :show
  end

  member_action :reset_password, :method => :put do
    user = User.find(params[:id])
    random_password = User.send(:generate_token, 'encrypted_password').slice(0, 8)
    user.password = random_password
    user.reset_password_token = User.reset_password_token
    user.reset_password_sent_at = Time.now
    user.save
    UserMailer.password_reset(user, random_password).deliver
    redirect_to :action => :show
  end

  collection_action :reset_all_passwords, :method => :post do
    begin
      User.find_each(:conditions => ['suspended == ?', false]) do |record|
        random_password = User.send(:generate_token, 'encrypted_password').slice(0, 8)
        record.password = random_password
        record.reset_password_token = User.reset_password_token
        record.reset_password_sent_at = Time.now
        record.save
        UserMailer.all_password_reset(record, random_password).deliver
      end
    rescue Exception => e
      logger.error "Error Resetting All Passwords: #{e.message}"
      redirect_to :action => :index, :alert => "Error resetting all passwords."
      return
    end
    redirect_to :action => :index, :notice => "All Passwords Reset"
  end

  collection_action :sign_out_all_users, :method => :post do
    User.force_active_users_to_sign_out
    redirect_to admin_dashboard_url, :notice => "All Users Signed out"
  end

  filter :id
  filter :email
  filter :name
  filter :current_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_at
  filter :last_sign_in_ip
  filter :sign_in_count
  filter :confirmation_sent_at
  filter :failed_attempts
  filter :created_at
  filter :suspended, :as => :select

  index do
    column "View" do |user|
      link_to "View", admin_user_path(user)
    end
    column :email
    column "User Profile" do |user|
      link_to user.display_name, [:admin, user.user_profile]
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :failed_attempts
    column :locked_at
    column :suspended
    column :created_at
    column "Destroy" do |user|
      if can? :destroy, user
        link_to "Destroy", [:admin, user], :method => :delete, :confirm => 'Are you sure you want to delete this user?'
      end
    end
  end

  show :title => :email do
    rows = default_attribute_table_rows.delete_if { |att| [:encrypted_password, :reset_password_token, :confirmation_token, :unlock_token].include?(att) }
    rows.insert(2, :user_profile)
    attributes_table *rows

#     active_admin_comments
  end
end
