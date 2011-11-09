ActiveAdmin.register PageSpace do
  menu :parent => "Pages", :if => proc{ can?(:read, PageSpace) }
  controller.authorize_resource
  
  actions :index, :show, :update, :edit, :destroy
  
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
    attributes_table :id, :community, :name, :game, :created_at, :updated_at
    div do      
      panel("Pages") do
        table_for(page_space.pages) do
          column "Name" do |page|
            link_to page.name, [:admin, page]
          end
        end
      end
    end
    active_admin_comments
  end  
end
