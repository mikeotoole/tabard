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
    @character.save!
    redirect_to user_profile_url(current_user, anchor: "games", subdomain: "www")
  end

  def update
    @character.update_attributes(params[:character])
    redirect_to user_profile_url(current_user, anchor: "games", subdomain: "www")
  end

protected
  def create_or_find_character
    @character = @played_game.characters.find_by_id(params[:id])
    if @character.blank?
      case @played_game.game.name
      when Wow.game_name
        @character = WowCharacter.new(params[:wow_character])
      when Swtor.game_name
        @character = SwtorCharacter.new(params[:swtor_character])
      when Minecraft.game_name
        @character = MinecraftCharacter.new(params[:minecraft_character])
      else
        @character = CustomCharacter.new(params[:custom_character])
      end
      @character.played_game = @played_game
    end
  end
end
