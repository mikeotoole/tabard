ActiveAdmin.register User do
  # TODO Mike, Add scope for locked users.
  # TODO Mike, Need to remove the edit button in the show screen.
  # TODO Mike, Need to remove the new button in the index screen.
  menu :parent => "User", :priority => 1  
    
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
    column :current_sign_in_at
    column :last_sign_in_at
    column :failed_attempts
    column :locked_at
    column :created_at
    column "View" do |user|
      link_to "View", admin_user_path(user)
    end
    column "Destroy" do |user|
      link_to "Destroy", [:admin, user], :method => :delete, :confirm => 'Are you sure you want to delete this user?'
    end
  end
end
