class ApplicationController < ActionController::Base
  
  protected
    
    # Returns the currently logged in user or nil if there isn't one 
    def current_user
      return unless session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id]) 
    end 
    helper_method :current_user
    
    # Filter method to enforce a login requirement 
    # Apply as a before_filter on any controller you want to protect 
    def authenticate
      logged_in? ? true : access_denied 
    end
    
    # Predicate method to test for a logged in user 
    def logged_in?
      current_user.is_a? User
    end
    helper_method :logged_in?
    
    #predicate method to test for an active profile
    def profile_active?
      current_profile != nil
    end    
    helper_method :profile_active?
    
    # Returns the currently active_profile or nil if there isn't one 
    def current_profile
      return unless session[:profile_id]
      @current_profile ||= Profile.find_by_id(session[:profile_id]) 
    end    
    helper_method :current_profile
    
    def character_active?
      current_character != nil
    end    
    helper_method :character_active?
    
    def current_character
      return unless session[:character_id]
      @current_character ||= Character.find_by_id(session[:character_id]) 
    end    
    helper_method :current_character
    
    def access_denied 
      redirect_to login_path, :notice => "Please log in to continue" and return false 
    end
    
    
    # Returns the currently active theme folder name
    def current_theme
      return @theme = 'swtor-prime'
    end
    helper_method :current_theme
end
