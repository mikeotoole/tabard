ActiveAdmin.register PageSpace do
  menu :parent => "Pages", :if => proc{ can?(:read, PageSpace) }
  controller.authorize_resource
  
  actions :index, :show, :update, :edit, :destroy
  
  filter :id
  filter :name
  filter :game
  filter :created_at
  
  index do
    column "View" do |page_space|
      link_to "View", admin_page_space_path(page_space)
    end
    column :id
    column "Community" do |page_space|
      link_to page_space.community.name, [:admin, page_space.community]
    end
    column :name
    column :game, :sortable => :game_id
    column :created_at
    column "Destroy" do |page_space|
      if can? :destroy, page_space
        link_to "Destroy", [:admin, page_space], :method => :delete, :confirm => 'Are you sure you want to delete this page space?'
      end  
    end
  end
  
  show :title => proc{"#{page_space.community.name} - #{page_space.name}"} do
    attributes_table *default_attribute_table_rows
    div do      
      panel("Pages") do
        table_for(page_space.pages) do
          column "Name" do |page|
            link_to page.name, [:admin, page]
          end
          column "Poster" do |page|
            link_to page.poster.name, [:admin, page.poster]
          end
        end
      end
    end
#     active_admin_comments
  end
  
  form do |f|
    f.inputs "Page Space Details" do
      f.input :game
      f.input :name
    end
    f.buttons
  end    
end
