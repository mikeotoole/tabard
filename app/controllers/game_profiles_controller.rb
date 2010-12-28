class GameProfilesController < ProfilesController
  
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
  
end
