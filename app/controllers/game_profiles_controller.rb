class GameProfilesController < ProfilesController
  before_filter :authenticate  
    
  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = Profile.find(params[:id])
    @game = Game.file(@profile.game_id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.xml
  def new
    flash.now[:alert] = "Please create a game profile."
    @profile = GameProfile.new
    @profile.type_helper = "GameProfile"
    @profile.user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

end
