ActiveAdmin.register Minecraft do
  menu label: "Game Minecraft", parent: "Game and Character", if: proc{ can?(:read, Minecraft) }
  controller.authorize_resource

  actions :index, :show, :edit, :update, :new, :create

  filter :id
  filter :server_type, as: :select, collection: Minecraft::VALID_SERVER_TYPES
  filter :created_at
  filter :updated_at

  index title: "Minecraft" do
    column "View" do |minecraft|
      link_to "View", admin_minecraft_path(minecraft)
    end
    column :id
    column :server_type
    column "Edit" do |minecraft|
      if can? :edit, minecraft
        link_to "Edit", edit_admin_minecraft_path(minecraft)
      end
    end
  end

  show title: :full_name do
    attributes_table *default_attribute_table_rows

    div do
      panel("Supported Games") do
        table_for(minecraft.supported_games) do
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
    f.inputs "Minecraft Details" do
      f.input :server_type, as: :select, collection: Minecraft::VALID_SERVER_TYPES
    end
    f.actions
  end
end
