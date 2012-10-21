ActiveAdmin.register PageSpace do
  menu parent: "Pages", if: proc{ can?(:read, PageSpace) }
  controller.authorize_resource

  actions :index, :show, :update, :edit, :destroy

  filter :id
  filter :name
  filter :created_at

  index do
    column "View" do |page_space|
      link_to "View", alexandria_page_space_path(page_space)
    end
    column :id
    column "Community" do |page_space|
      link_to page_space.community_name, [:alexandria, page_space.community]
    end
    column :name
    column :supported_game, sortable: :supported_game_id
    column :created_at
  end

  show title: proc{"#{page_space.community_name} - #{page_space.name}"} do
    attributes_table *default_attribute_table_rows
    div do
      panel("Pages") do
        table_for(page_space.pages) do
          column "Name" do |page|
            link_to page.name, [:alexandria, page]
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Page Space Details" do
      f.input :supported_game, collection: f.object.community.supported_games
      f.input :name
    end
    f.actions
  end
end
