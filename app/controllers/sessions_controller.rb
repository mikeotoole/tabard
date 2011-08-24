=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for sessions (logging in and out).
=end
class SessionsController < ApplicationController

  def create
    if user = User.authenticate(params[:email], params[:password])

      cookies.permanent.signed[:remember_token] = {:value => user.id, :domain => :all} if params[:remember]
      session[:user_id] = user.id

      if user.user_profile == nil
        @profile_type = "UserProfile"
        add_new_flash_message("Logged in as <em>#{user.name}</em>." +
          " Please create a <a href=\"#{new_profile_path}\">new profile</a>" +
          " to finish setting up your account.")
        redirect_to new_profile_path
      else
        add_new_flash_message("Welcome back, <em>#{user.name}</em>.")
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
    add_new_flash_message("You successfully logged out") if logged_in?
    reset_session
    cookies.delete :remember_token, :domain => :all
    redirect_to root_path
  end
end
