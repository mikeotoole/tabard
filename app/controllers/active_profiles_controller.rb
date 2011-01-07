class ActiveProfilesController < ApplicationController
  before_filter :authenticate
  def create  
    #Check to see what profile is being used
    #Add the profile_id to session
    #session[:profile_id] = whatever
    #Redirect to root?
    session[:profile_id] = params[:active_profile][:profile_id]
    redirect_to root_path, :notice => "Profile activated."
  end
  
  def update
    #Set to new session[:profile_id]
  end
  
  def destroy 
    #Unset the session[:profile_id]
    session[:profile_id] = nil
    redirect_to root_path, :notice => "Profile deactivated."
  end
end
