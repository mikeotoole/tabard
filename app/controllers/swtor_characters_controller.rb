###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for Star Wars the Old Republic characters.
###
class SwtorCharactersController < ApplicationController
  respond_to :html, :js
###
# Callbacks
###
  prepend_before_filter :authenticate_user!, :except => :show
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => :update

###
# REST Actions
###
  # GET /swtor_characters/:id(.:format)
  def show
    respond_with(@swtor_character)
  end

  # GET /swtor_characters/new
  def new
  end

  # GET /swtor_characters/:id/edit(.:format)
  def edit
  end

  # POST /swtor_characters(.:format)
  def create
    swtor = Swtor.find(:first, :conditions => {:faction => params[:swtor_character][:faction], :server_name => params[:swtor_character][:server_name]})
    params[:swtor_character][:swtor_id] = swtor.id if swtor 
    @swtor_character = SwtorCharacter.create(params[:swtor_character])

    if @swtor_character.valid?
      profile = current_user.user_profile
      proxy = profile.character_proxies.build(:character => @swtor_character, :default_character => params[:swtor_character][:default])
      add_new_flash_message('Character was successfully created.') if proxy.save
    end  
      
    respond_with(@swtor_character)
  end

  # PUT /swtor_characters/:id(.:format)
  def update
    @swtor_character = SwtorCharacter.find(params[:id])
    authorize!(:update, @swtor_character)

    swtor = Swtor.find(:first, :conditions => {:faction => params[:swtor_character][:faction], :server_name => params[:swtor_character][:server_name]})
    @swtor_character.swtor = swtor if swtor
    add_new_flash_message('Character was successfully updated.') if @swtor_character.update_attributes(params[:swtor_character])
    respond_with(@swtor_character)
  end

  # DELETE /swtor_characters/:id(.:format)
  def destroy
    if @swtor_character
      add_new_flash_message('Character was successfully deleted.') if @swtor_character.destroy
    end
    respond_with(@swtor_character)
  end
end
