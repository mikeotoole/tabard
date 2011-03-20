class ActiveProfilesController < ApplicationController
  before_filter :authenticate
  
  def create    
    if defined? params[:type].constantize
      profile = params[:type].constantize.find_by_id(params[:id])
      
      session[:profile_id] = params[:id]    
      session[:profile_type] = params[:type]
    end  
    
    if profile
      active_profile_name = profile.name
      redirect_to root_path, :notice => "Profile <em>#{active_profile_name}</em> activated."
      return
    else
      redirect_to root_path, :alert => "Error setting active profile"
      return
    end    
  end
  
  # def update
  #   #Set to new session[:profile_id]
  # end
  # 
  # def destroy 
  #   #Unset the session[:profile_id]
  #   session[:profile_id] = nil
  #   session[:character_id] = nil
  #   redirect_to root_path, :notice => "Profile deactivated."
  # end
end
