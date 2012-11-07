ActiveAdmin.register CommunityGame do
  menu parent: "Community", if: proc{ can?(:read, CommunityGame) }
  controller.authorize_resource

  actions :index, :show, :destroy

  filter :id
  filter :name
  filter :game
  filter :created_at

  index do
    column "View" do |community_game|
      link_to "View", alexandria_community_game_path(community_game)
    end
    column :id
    column "Community" do |community_game|
      link_to community_game.community_name, [:alexandria, community_game.community]
    end
    column :game, sortable: :game_id
    column :full_name
    column :created_at
    column "Destroy" do |community_game|
      if can? :destroy, community_game
        link_to "Destroy", [:alexandria, community_game], method: :delete, confirm: 'Are you sure you want to delete this community game?'
      end
    end
  end

  show title: proc{"#{community_game.community_name} - #{community_game.game_name}"} do
    attributes_table *default_attribute_table_rows
    #active_admin_comments
  end
end
