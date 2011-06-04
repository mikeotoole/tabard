class SessionsController < ApplicationController
  def new
    #should make sure this is in the same domain...
    session[:pre_login_url] = request.env["HTTP_REFERER"]  
  end  
  
  def create  
    if user = User.authenticate(params[:email], params[:password])
      if !user.user_profile.is_active
        if user.user_profile.is_applicant
          redirect_to root_path, :alert => "Your application has not been approved yet."
        else
          redirect_to root_path, :alert => "You are not authorized to access the site."
        end       
        return
      end
      
      session[:user_id] = user.id
      if user.user_profile == nil
        @profile_type = "UserProfile"
        redirect_to new_profile_path, :notice => (
          "Logged in as <em>#{user.name}</em>." +
          " Please create a <a href=\"#{new_profile_path}\">new profile</a>" +
          " to finish setting up your account."
        )
      else
        if session[:pre_login_url] 
          redirect_to session[:pre_login_url], :notice => "Welcome back, <em>#{user.user_profile.name}</em>."
        else
          redirect_to root_path, :notice => "Welcome back, <em>#{user.user_profile.name}</em>."
        end        
      end 
    else
      redirect_to root_path, :alert => "Invalid email/password combination."
    end
  end
  
  def destroy 
    reset_session 
    redirect_to root_path, :notice => "You successfully logged out"
  end
end
