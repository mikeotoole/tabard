class GameProfilesController < ProfilesController
  respond_to :html, :xml
  before_filter :authenticate  

  def show
    @profile = Profile.find(params[:id])
    @game = Game.file(@profile.game_id)

    respond_with(@game, @profile)
  end

  def new
    add_new_flash_message("Please create a game profile.","alert")
    @profile = GameProfile.new
    @profile.type_helper = "GameProfile"
    @profile.user = current_user
    respond_with(@profile)
  end

end
