class CharactersController < ApplicationController
  respond_to :html, :js
  load_and_authorize_resource :played_game, only: [:new, :create]
  before_filter :create_or_find_character, only: [:new, :create]
  load_resource :character, except: [:new, :create]
  authorize_resource :character

  def new
  end

  def edit
  end

  def create
    flash[:success] = "Your character has been created." if @character.save!
    respond_with(@character, location: user_profile_url(current_user, anchor: "games", subdomain: "www"))
  end

  def update
    flash[:success] = "Your character has been updated." if @character.update_attributes(params[:character])
    respond_with(@character, location: user_profile_url(current_user, anchor: "games", subdomain: "www"))
  end

  def destroy
    flash[:notice] = 'Character has been removed.' if @character.destroy
    redirect_to user_profile_url(current_user, anchor: "games", subdomain: "www")
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
