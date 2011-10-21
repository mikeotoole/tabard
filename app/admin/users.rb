ActiveAdmin.register User do
  # TODO Mike, Add scope for locked users.
  menu :parent => "User", :priority => 1  
  controller.authorize_resource
    
  filter :email
  filter :current_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_at
  filter :last_sign_in_ip
  filter :sign_in_count
  filter :confirmation_sent_at
  filter :failed_attempts
  filter :created_at
  
  index do
    column :email
    column "User Profile" do |user|
      link_to user.display_name, [:admin, user.user_profile]
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :failed_attempts
    column :locked_at
    column :created_at
    column "View" do |user|
      link_to "View", admin_user_path(user)
    end
    column "Destroy" do |user|
      if can? :destroy, user
        link_to "Destroy", [:admin, user], :method => :delete, :confirm => 'Are you sure you want to delete this user?'
      end  
    end
  end
  
  show do
    attributes_table :id, :email, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, 
    :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :failed_attempts, 
    :unlock_token, :locked_at, :created_at, :updated_at, :user_profile
    active_admin_comments
  end
end