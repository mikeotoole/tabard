ActiveAdmin.register Wow, :as => "Wow" do
  menu :label => "Game World of Warcraft", :parent => "Game and Character", :if => proc{ can?(:read, Wow) }
  controller.authorize_resource

  actions :index, :show, :edit, :update, :new, :create

  filter :id
  filter :faction, :as => :select, :collection => Wow::VALID_FACTIONS
  filter :server_name
  filter :server_type, :as => :select, :collection => Wow::VALID_SERVER_TYPES
  filter :created_at
  filter :updated_at

  index :title => "World of Warcraft" do
    column "View" do |wow|
      link_to "View", admin_wow_path(wow)
    end
    column :id
    column :faction
    column :server_name
    column :server_type
    column "Edit" do |wow|
      if can? :edit, wow
        link_to "Edit", edit_admin_wow_path(wow)
      end
    end
  end

  show :title => :name do
    attributes_table *default_attribute_table_rows

    div do
      panel("Supported Games") do
        table_for(wow.supported_games) do
          column "Name" do |supported_game|
            link_to supported_game.name, [:admin, supported_game]
          end
          column :game_full_name
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs "WoW Details" do
      f.input :faction, :as => :select, :collection => Wow::VALID_FACTIONS
      f.input :server_name
      f.input :server_type, :as => :select, :collection => Wow::VALID_SERVER_TYPES
    end
    f.buttons
  end
end
