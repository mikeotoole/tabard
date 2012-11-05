class CharactersController < ApplicationController
  respond_to :html, :js
  load_and_authorize_resource :played_game, only: [:new, :create]
  before_filter :create_or_find_character, only: [:new, :create]
  load_resource :character, only: [:edit, :update, :destroy]
  authorize_resource :character

  # GET /played_games/:played_game_id/characters/new
  def new
  end

  # POST /played_games/:played_game_id/characters
  def create
    flash[:success] = "Your character has been created." if @character.save!
    respond_with(@character, location: user_profile_url(current_user.user_profile, anchor: "games", subdomain: "www"))
  end

  # GET /characters/:id/edit
  def edit
  end

  # PUT /characters/:id
  def update
    flash[:success] = "Your character has been updated." if @character.update_attributes(params[:character])
    respond_with(@character, location: user_profile_url(current_user.user_profile, anchor: "games", subdomain: "www"))
  end

  # DELETE /characters/:id
  def destroy
    flash[:notice] = 'Character has been removed.' if @character.destroy
    redirect_to user_profile_url(current_user.user_profile, anchor: "games", subdomain: "www")
  end

protected
  def create_or_find_character
    @character = @played_game.characters.find_by_id(params[:id])
    if @character.blank?
      case @played_game.game.name
        when Wow.game_name
          @character = WowCharacter.new(params[:character])
        when Swtor.game_name
          @character = SwtorCharacter.new(params[:character])
        when Minecraft.game_name
          @character = MinecraftCharacter.new(params[:character])
        else
          @character = CustomCharacter.new(params[:character])
      end
      @character.played_game = @played_game
    end
  end
end
