class Management::GamesController < Communities::CommunitiesController
  before_filter :authenticate
  respond_to :html, :xml   
   
   
  # GET /management/games
  # GET /management/games.xml
  def index
    if !current_user.can_show("Game") 
      render_insufficient_privileges
    else 
      @games = Game.all
      respond_with(@games)
    end
  end

  # GET /management/games/new
  # GET /management/games/new.xml
  def new
    if !current_user.can_create("Game") 
      render_insufficient_privileges
    else 
      @game = Game.new
      respond_with(@game)
    end
  end

  # GET /management/games/1/edit
  def edit
    if !current_user.can_update("Game") 
      render_insufficient_privileges
    else 
      @game = Game.find(params[:id])
    end
  end

  # POST /management/games
  # POST /management/games.xml
  def create
    if !current_user.can_create("Game") 
      render_insufficient_privileges
    else 
      @game = Game.new(params[:game])
  
      respond_to do |format|
        if @game.save
          add_new_flash_message('Game was successfully created.')
          format.html { redirect_to(management_games_path) }
          format.xml  { render :xml => @game, :status => :created, :location => @game }
        else
          grab_all_errors_from_model(@game)
          format.html { render :action => "new" }
          format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /management/games/1
  # PUT /management/games/1.xml
  def update
    if !current_user.can_update("Game") 
      render_insufficient_privileges
    else 
      @game = Game.find(params[:id])
  
      respond_to do |format|
        if @game.update_attributes(params[:game])
          add_new_flash_message('Game was successfully updated.')
          format.html { redirect_to(management_games_path) }
          format.xml  { head :ok }
        else
          grab_all_errors_from_model(@game)
          format.html { render :action => "edit" }
          format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /management/games/1
  # DELETE /management/games/1.xml
  def destroy
    if !current_user.can_delete("Game") 
      render_insufficient_privileges
    else 
      @game = Game.find(params[:id])
      if @game.destroy
        add_new_flash_message('Game was successfully deleted.')
      end
  
      respond_to do |format|
        format.html { redirect_to(management_games_path) }
        format.xml  { head :ok }
      end
    end
  end
end
