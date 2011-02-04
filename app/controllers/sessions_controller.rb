class SessionsController < ApplicationController
  def create  
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      if user.user_profile == nil
        @profile_type = "UserProfile"
        redirect_to new_profile_path, :notice => "Logged in successfully. Please create a user profile to finish setting up your account."
      else
        redirect_to root_path, :notice => "Logged in successfully."
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
