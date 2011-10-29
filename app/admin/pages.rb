ActiveAdmin.register Page do
  menu :parent => "Pages"
  controller.authorize_resource
  
  filter :id
  filter :name
  filter :markup
  filter :created_at
  filter :show_in_navigation, :as => :select
  
  index do
    column :id
    column :name
    column :page_space
    column :poster
    column :created_at       
    column "View" do |page|
      link_to "View", admin_page_path(page)
    end
    column "Destroy" do |page|
      if can? :destroy, page
        link_to "Destroy", [:admin, page], :method => :delete, :confirm => 'Are you sure you want to delete this page?'
      end  
    end
  end
  
  show do
    attributes_table :name, :markup, :body, :page_space, :user_profile, :poster, :community, :created_at, :updated_at, :show_in_navigation
    active_admin_comments
  end  
end
