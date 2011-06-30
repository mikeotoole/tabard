class SessionsController < ApplicationController
  def new
    #should make sure this is in the same domain...
    #session[:pre_login_url] = request.env["REQUEST_URI"] 
  end  
  
  def create  
    if user = User.authenticate(params[:email], params[:password])
      if !user.user_profile.is_active
        if user.user_profile.is_applicant
          add_new_flash_message("Your application has not been approved yet.","alert")
          redirect_to root_path
        else
          add_new_flash_message("You are not authorized to access the site.","alert")
          redirect_to root_path
        end       
        return
      end

      cookies.permanent.signed[:remember_token] = user.id if params[:remember]
      session[:user_id] = user.id
      
      if user.user_profile == nil
        @profile_type = "UserProfile"
        add_new_flash_message("Logged in as <em>#{user.name}</em>." +
          " Please create a <a href=\"#{new_profile_path}\">new profile</a>" +
          " to finish setting up your account.")
        redirect_to new_profile_path
      else
        add_new_flash_message("Welcome back, <em>#{user.user_profile.name}</em>.")
        if session[:pre_login_url]  
          redirect_to session[:pre_login_url]
        else
          redirect_to root_path
        end        
      end 
    else
      add_new_flash_message("Invalid email/password combination.")
      redirect_to root_path
    end
  end
  
  def destroy 
    reset_session 
    cookies.delete(:remember_token)
    add_new_flash_message("You successfully logged out")
    redirect_to root_path
  end
end
