class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :group_flash_messages, :set_local
  after_filter :clear_flash_messages
  
  # Puts all of the notices and alerts into the messages array
  def group_flash_messages
    if alert.present?
      flash[:messages] = Array.new unless flash[:messages]
      flash[:messages] << { :class => 'alert', :body => alert }
    end
    if notice.present?
     flash[:messages] = Array.new unless flash[:messages]
     flash[:messages] << { :class => 'notice', :body => notice }
    end
  end
  
  # Removes all flash messages
  def clear_flash_messages
    flash[:messages] = Array.new
  end  
  
  protected
    def set_local
      I18n.locale = params[:locale] unless params[:locale].blank?
    end
    
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
    
    # Lets the view know if there are announcements to be displayed 
    def has_announcements?
      logged_in? && current_user.unacknowledged_announcements
    end
    helper_method :has_announcements?
    
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
      redirect_to root_path, :alert => "Please log in to continue" and return false 
    end
    
    # Varibles for navigation
    def nav_discussions
      DiscussionSpace.all.delete_if {|discussion_space| !discussion_space.check_user_show_permissions(current_user) or !discussion_space.list_in_navigation}
    end
    
    helper_method :nav_discussions
    
    def nav_page_spaces
      PageSpace.all.delete_if {|page_space| !page_space.check_user_show_permissions(current_user)}
    end
    
    helper_method :nav_page_spaces
    
    def nav_featured_pages
      Page.featured_pages.alphabetical
    end
    
    helper_method :nav_featured_pages
    
    # Returns the currently active theme folder name
    def current_theme
      return @theme = 'swtor-prime'
    end
    helper_method :current_theme
end
