ActiveAdmin.register AdminUser do
  menu :parent => "User", :priority => 11
  controller.authorize_resource

  action_item :only => :show do
    if can? :reset_password, admin_user
      link_to "Reset Password", reset_password_admin_admin_user_path(admin_user), :method => :put, :confirm => 'Are you sure you want to reset user password?'
    end  
  end
  
  action_item :only => :index do
    if can? :reset_all_passwords, AdminUser.new
      link_to "Reset All Passwords", reset_all_passwords_admin_admin_users_path, :method => :post, :confirm => 'Are you sure you want to reset ALL admin user passwords?'
    end  
  end  

  member_action :reset_password, :method => :put do
    admin_user = AdminUser.find(params[:id])
    random_password = AdminUser.send(:generate_token, 'encrypted_password').slice(0, 8)
    admin_user.password = random_password
    admin_user.reset_password_token = AdminUser.reset_password_token
    admin_user.reset_password_sent_at = Time.now    
    admin_user.save
    UserMailer.password_reset(admin_user, random_password).deliver 
    redirect_to :action => :show
  end

  collection_action :reset_all_passwords, :method => :post do
    begin
      AdminUser.all.each do |record|
        # Assign a random password
        random_password = AdminUser.send(:generate_token, 'encrypted_password').slice(0, 8)
        record.password = random_password
        record.reset_password_token = AdminUser.reset_password_token
        record.reset_password_sent_at = Time.now   
        record.save
        UserMailer.all_password_reset(record, random_password).deliver  
      end
    rescue Exception => e
      puts "Error: #{e.message}"
      # TODO Mike, Handle this error.
    end
    redirect_to :action => :index, :notice => "All Passwords Reset"
  end

  filter :email
  filter :current_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_at
  filter :last_sign_in_ip
  filter :created_at
  
  index do
    column :email
    column :current_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_at
    column :last_sign_in_ip
    column :sign_in_count
    column :created_at
    column "View" do |admin_user|
      link_to "View", admin_admin_user_path(admin_user)
    end
    column "Destroy" do |admin_user|
      if can? :destroy, admin_user
        link_to "Destroy", [:admin, admin_user], :method => :delete, :confirm => 'Are you sure you want to delete this user?'
      end  
    end
  end
  
  form do |f|
    f.inputs "Admin Details" do
      f.input :email
    end
    f.buttons
  end
end