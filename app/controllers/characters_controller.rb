class CharactersController < ApplicationController
  respond_to :html, :js
  load_and_authorize_resource :played_game, only: [:new, :create]
  before_filter :create_character, only: [:new, :create]
  load_resource :character, only: [:edit, :update, :destroy]
  authorize_resource :character

  # GET /played_games/:played_game_id/characters/new
  def new
  end

  # POST /played_games/:played_game_id/characters
  def create
    flash.now[:success] = "Your character has been created." if @character.save
    @character.find_and_upload_avatar_from_game
    respond_with(@character, location: user_profile_url(current_user.user_profile, anchor: "games", subdomain: "www"))
  end

  # GET /characters/:id/edit
  def edit
  end

  # PUT /characters/:id
  def update
    flash.now[:success] = "Your character has been updated." if @character.update_attributes(params[:character])
    @character.find_and_upload_avatar_from_game
    respond_with(@character, location: user_profile_url(current_user.user_profile, anchor: "games", subdomain: "www"))
  end

  # DELETE /characters/:id
  def destroy
    if @character.destroy
      flash.now[:notice] = 'Character has been removed.'
      if last_posted_as_character?(@character)
        session[:poster_type] = nil
        session[:poster_id] = nil
      end
    end
    redirect_to user_profile_url(current_user.user_profile, anchor: "games", subdomain: "www")
  end

protected
  def create_character
      @character = @played_game.new_character(params[:character])
  end
end
