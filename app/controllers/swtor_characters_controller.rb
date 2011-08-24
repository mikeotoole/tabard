=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for Star Wars the Old Republic characters.
=end
class SwtorCharactersController < ApplicationController
  before_filter :authenticate, :except => [:new]
  respond_to :html, :js

  def edit
    @character = SwtorCharacter.find_by_id(params[:id])
    if !current_user.can_update(@character)
        render_insufficient_privileges
    end
  end

  def show
      @character = SwtorCharacter.find_by_id(params[:id])
      if !current_user.can_show(@character)
        render_insufficient_privileges
      else
        @game = Game.find_by_id(@character.game_id) if @character
        respond_with(@character)
      end
  end

  def new
      @character = SwtorCharacter.new
      #TODO fix this
      # if !current_user.can_create(@character)
      #   render :nothing => true, :status => :forbidden
      # else
        @character.game_id = params[:game_id]

        respond_with(@character)
      # end
  end

  def create
    @character = SwtorCharacter.new(params[:swtor_character])
    if !current_user.can_create(@character)
      render_insufficient_privileges
    else
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
  end

  def update
    @character = SwtorCharacter.find_by_id(params[:id])
    if !current_user.can_update(@character)
      render_insufficient_privileges
    else
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
  end

  def destroy
    @character = SwtorCharacter.find_by_id(params[:id])
    if !current_user.can_delete(@character)
      render_insufficient_privileges
    else
      @character.destroy if @character
      add_new_flash_message('Character was successfully deleted.')
      respond_to do |format|
        format.html { redirect_to user_profile_path(UserProfile.find(current_user)) }
        format.xml  { head :ok }
      end
    end
  end
end
