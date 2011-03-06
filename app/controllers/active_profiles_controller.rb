class ActiveProfilesController < ApplicationController
  before_filter :authenticate
  def create  
    #Check to see what profile is being used
    #Add the profile_id to session
    #session[:profile_id] = whatever
    #Redirect to root?
    if params[:active_profile][:character_id] == "-1" 
      session[:profile_id] = current_user.user_profile_id
    else 
      session[:character_id] = params[:active_profile][:character_id]
      session[:profile_id] = CharacterProxy.find_by_character_id(params[:active_profile][:character_id]).active_profile_id
    end
    redirect_to root_path, :notice => "Profile activated."
  end
  
  def update
    #Set to new session[:profile_id]
  end
  
  def destroy 
    #Unset the session[:profile_id]
    session[:profile_id] = nil
    session[:character_id] = nil
    redirect_to root_path, :notice => "Profile deactivated."
  end
end
