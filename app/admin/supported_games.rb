ActiveAdmin.register SupportedGame do
  menu :parent => "Community", :if => proc{ can?(:read, SupportedGame) }
  controller.authorize_resource

  actions :index, :show, :edit, :destroy

  controller do
    def update
      @supported_game = SupportedGame.find(params[:id])
      game_class = @supported_game.game_type.constantize
      game = game_class.find(:first, :conditions => {:faction => params[:supported_game][:faction], :server_name => params[:supported_game][:server_name]}) if game_class.superclass.name == "Game"
      if game
        @supported_game.game = game
      else
        @supported_game.game = game_class.new(:faction => params[:supported_game][:faction], :server_name => params[:supported_game][:server_name])  if game_class.superclass.name == "Game"
      end
      
      flash[:notice] = 'Supported game was successfully updated.' if @supported_game.update_attributes(params[:supported_game])
  
      if @supported_game.valid?
        redirect_to :action => :show
      else
        render :action => :edit
      end  
    end
  end  

  filter :id
  filter :name
  filter :game
  filter :created_at

  index do
    column "View" do |supported_game|
      link_to "View", admin_supported_game_path(supported_game)
    end
    column :id
    column "Community" do |supported_game|
      link_to supported_game.community_name, [:admin, supported_game.community]
    end
    column :name
    column :game, :sortable => :game_id
    column :created_at
    column "Destroy" do |supported_game|
      if can? :destroy, supported_game
        link_to "Destroy", [:admin, supported_game], :method => :delete, :confirm => 'Are you sure you want to delete this supported game?'
      end
    end
  end

  show :title => proc{"#{supported_game.community_name} - #{supported_game.name}"} do
    attributes_table *default_attribute_table_rows
#     active_admin_comments
  end

  form do |f|
    f.inputs "Supported Game Details" do
      f.input :faction, :collection => f.object.game.all_factions
      f.input :server_name, :label => 'Server', :collection => f.object.game.all_servers
      f.input :name
    end
    f.buttons
  end
end