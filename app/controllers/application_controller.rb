class ApplicationController < ActionController::Base
  protected 
    # Returns the currently logged in user or nil if there isn't one 
    def current_user
      return unless session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id]) 
    end
    # Make current_user available in templates as a helper 
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
    
    # Make logged_in? available in templates as a helper 
    helper_method :logged_in?
    
    def access_denied 
      redirect_to login_path, :notice => "Please log in to continue" and return false 
    end
end
