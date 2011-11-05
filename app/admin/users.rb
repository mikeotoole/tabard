ActiveAdmin.register User do
  menu :parent => "User", :priority => 1, :if => proc{ can?(:read, User) } 
  controller.authorize_resource
  
  action_item :only => :show do
    if user.user_active and can? :lock, user
      link_to "Lock User", lock_admin_user_path(user), :method => :put, :confirm => 'Are you sure you want to lock this user?'
    end  
  end 

  action_item :only => :show do
    if !user.user_active and can? :unlock, user
      link_to "Unlock User", unlock_admin_user_path(user), :method => :put, :confirm => 'Are you sure you want to unlock this user?'
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
  
  member_action :lock, :method => :put do
    user = User.find(params[:id])
    user.user_active = false
    user.save
    redirect_to :action => :show
  end

  member_action :unlock, :method => :put do
    user = User.find(params[:id])
    user.user_active = true
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
      User.find_each(:conditions => ['user_active == ?', true]) do |record|
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
    redirect_to previous_page, :notice => "All Users Signed out"
  end 
    
  filter :email
  filter :current_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_at
  filter :last_sign_in_ip
  filter :sign_in_count
  filter :confirmation_sent_at
  filter :failed_attempts
  filter :created_at
  filter :user_active
  
  index do
    column :email
    column "User Profile" do |user|
      link_to user.display_name, [:admin, user.user_profile]
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :failed_attempts
    column :locked_at
    column :user_active
    column :created_at
    column "View" do |user|
      if can? :read, user
        link_to "View", admin_user_path(user)
      end  
    end
    column "Destroy" do |user|
      if can? :destroy, user
        link_to "Destroy", [:admin, user], :method => :delete, :confirm => 'Are you sure you want to delete this user?'
      end  
    end
  end
  
  show do
    attributes_table :id, :email, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, 
    :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :user_active, :confirmation_token, :confirmed_at, :confirmation_sent_at, :failed_attempts, 
    :unlock_token, :locked_at, :created_at, :updated_at, :user_profile
    active_admin_comments
  end
end