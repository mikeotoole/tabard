ActiveAdmin.register Game do
  menu parent: "Game and Character", if: proc{ can?(:read, Game) }
  controller.authorize_resource

  actions :index, :show, :edit, :update, :new, :create

  filter :id
  filter :name
  filter :aliases
  filter :created_at
  filter :updated_at

  index do
    column "View" do |game|
      link_to "View", alexandria_game_path(game)
    end
    column :id
    column :name
    column :created_at
    column "Edit" do |game|
      if can? :edit, game
        link_to "Edit", edit_alexandria_game_path(game)
      end
    end
  end

  show title: :name do
    attributes_table *default_attribute_table_rows

    div do
      panel("Community Games") do
        table_for(game.community_games) do
          column "Community Name" do |community_game|
            link_to community_game.community_name, [:alexandria, community_game]
          end
          column :full_name
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs "Game Details" do
      f.input :name
      f.input :aliases
      #f.input :info, as: :text
    end
    f.buttons
  end
end
