ActiveAdmin.register CommunityGame do
  menu parent: "Community", if: proc{ can?(:read, CommunityGame) }
  controller.authorize_resource

  actions :index, :show, :edit, :destroy

  member_action :update, method: :put do
    @community_game = CommunityGame.find(params[:id])
    game_class = @community_game.game_type.constantize
    game = game_class.find(:first, conditions: {faction: params[:community_game][:faction], server_name: params[:community_game][:server_name]}) if game_class.superclass.name == "Game"
    if game
      @community_game.game = game
    else
      @community_game.game = game_class.new(faction: params[:community_game][:faction], server_name: params[:community_game][:server_name])  if game_class.superclass.name == "Game"
    end

    flash[:notice] = 'Community game was successfully updated.' if @community_game.update_attributes(params[:community_game])

    if @community_game.valid?
      redirect_to action: :show
    else
      render action: :edit
    end
  end

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
    column :name
    column :game, sortable: :game_id
    column :created_at
    column "Destroy" do |community_game|
      if can? :destroy, community_game
        link_to "Destroy", [:alexandria, community_game], method: :delete, confirm: 'Are you sure you want to delete this community game?'
      end
    end
  end

  show title: proc{"#{community_game.community_name} - #{community_game.name}"} do
    attributes_table *default_attribute_table_rows
    active_admin_comments
  end

  form do |f|
    f.inputs "Community Game Details" do
      f.input :faction, collection: f.object.game.all_factions if f.object.game.respond_to?(:all_factions)
      f.input :server_name, label: 'Server', collection: f.object.game.all_servers if f.object.game.respond_to?(:all_servers)
      f.input :name
    end
    f.buttons
  end
end
