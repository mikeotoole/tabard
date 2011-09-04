###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for Star Wars the Old Republic characters.
###
class SwtorCharactersController < ApplicationController
  ###
  # Before Filters
  ###
  #TODO why does this exclude new?
  before_filter :authenticate_user!, :except => [:new]
  
  respond_to :html, :js

	# GET /games/:game_id/swtor_characters/:id/edit(.:format)
  def edit
    @character = SwtorCharacter.find_by_id(params[:id])
  end

	# GET /games/:game_id/swtor_characters/:id(.:format)
	# GET /swtor_characters/:id(.:format)
  def show
    @character = SwtorCharacter.find_by_id(params[:id])
    @game = Game.find_by_id(@character.game_id) if @character
    
  	respond_with(@character)
  end

	# GET /games/:game_id/swtor_characters/new(.:format)
  def new
    @character = SwtorCharacter.new
    @character.game_id = params[:game_id]

    respond_with(@character)
  end

	# POST /games/:game_id/swtor_characters(.:format)
  def create
    @character = SwtorCharacter.new(params[:swtor_character])
    profile = UserProfile.find_by_user_id(current_user.id)
    profile.build_character(@character, params[:default])

    respond_to do |format|
      if profile.save
        add_new_flash_message('Character was successfully created.')
        format.html { redirect_to([@character.game, @character]) }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        grab_all_errors_from_model(profile)
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

	# PUT /games/:game_id/swtor_characters/:id(.:format)
  def update
    @character = SwtorCharacter.find_by_id(params[:id])
    @game = Game.find_by_id(@character.game_id) if @character

    if params[:default]
      @gameProfile = CharacterProxy.character_game_profile(@character)
      @gameProfile.default_character_proxy_id = @character.character_proxy_id if @gameProfile
      @gameProfile.save if @gameProfile
    end

    if @character.update_attributes(params[:swtor_character])
      add_new_flash_message('Character was successfully updated.')
      respond_with(@game, @character)
    else
      grab_all_errors_from_model(@character)
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end
	
	# DELETE /games/:game_id/swtor_characters/:id(.:format)
  def destroy
    @character = SwtorCharacter.find_by_id(params[:id])
    
    #TODO Is this checking for successful destroy?
    @character.destroy if @character
    add_new_flash_message('Character was successfully deleted.')
    respond_to do |format|
      format.html { redirect_to user_profile_path(UserProfile.find(current_user)) }
      format.xml  { head :ok }
    end
  end
end
