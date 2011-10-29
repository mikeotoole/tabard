ActiveAdmin.register PageSpace do
  menu :parent => "Pages"
  controller.authorize_resource
  
  filter :id
  filter :name
  filter :game
  filter :created_at
  
  index do
    column :id
    column :community
    column :name
    column :game
    column :created_at
    column "View" do |page_space|
      link_to "View", admin_page_space_path(page_space)
    end
    column "Destroy" do |page_space|
      if can? :destroy, page_space
        link_to "Destroy", [:admin, page_space], :method => :delete, :confirm => 'Are you sure you want to delete this page space?'
      end  
    end
  end
  
  show do
    attributes_table :community, :name, :game, :created_at, :updated_at
    h3 "Pages:"
    page_space.pages.each do |page|
      div do
        link_to page.name, [:admin, page]
      end  
    end
    active_admin_comments
  end  
end
