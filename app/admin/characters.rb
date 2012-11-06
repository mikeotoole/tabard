ActiveAdmin.register Character do
  menu parent: "Game and Character", if: proc{ can?(:read, Character) }
  controller.authorize_resource

  actions :index, :show, :destroy

  filter :id
  filter :name
  filter :played_game_user_profile_gamer_tag, as: :string, label: "Creator Gamer Tag"
  filter :played_game_game_name, as: :string, label: "Game Name"
  filter :is_removed, as: :select
  filter :created_at
  filter :updated_at

  index do
    column "View" do |character|
      link_to "View", alexandria_character_path(character)
    end
    column :id
    column :name
    column :game, sortable: false
    column "User Profile" do |character|
      link_to character.user_profile.gamer_tag, [:alexandria, character.user_profile]
    end
    column :created_at
    column "Destroy" do |character|
      if can? :destroy, character
        link_to "Destroy", [:alexandria, character], method: :delete, confirm: 'Are you sure you want to delete this character?'
      end
    end
  end

  show title: proc{"#{character.user_profile.display_name} - #{character.name}"} do
    attributes_table *default_attribute_table_rows, :game, :user_profile
    active_admin_comments
  end
end
