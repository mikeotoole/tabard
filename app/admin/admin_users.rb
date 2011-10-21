ActiveAdmin.register AdminUser do
  menu :parent => "User", :priority => 11
  controller.authorize_resource

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