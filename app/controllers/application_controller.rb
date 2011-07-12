class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_locale, :group_flash_messages, :collect_management_navigation_items
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
    flash[:messages] = []
  end  
  
  def add_new_flash_message(message_body, message_class="notice", message_title="")
    flash[:messages] = Array.new unless flash[:messages] 
    flash[:messages] << { :class => message_class, :title => message_title, :body => message_body }
  end
  helper_method :add_new_flash_message
  
  protected
  
  # Returns an Array with the users profile and characters info.
  def profiles
    if current_user
      profile_collection = current_user.active_profile_helper_collection
      profiles = Array.new  
      profile_collection.each do |profile| 
        profiles << { :name => profile.name, :is_current => (profile == @current_profile), :profile_id => profile.id, :type => profile.class }       
      end
      profiles
    end
  end
  helper_method :profiles
  
  # Predicate method to test for an active profile.
  def profile_active?
    session[:profile_type] =~ /UserProfile/ || character_active?
  end    
  helper_method :profile_active?
  
  def character_active?
    session[:profile_type] =~ /Character$/
  end
  helper_method :character_active?
  
  def current_character
    return unless character_active?
    if defined? session[:profile_type].constantize
      @current_profile ||= session[:profile_type].constantize.find_by_id(session[:profile_id])
    end
  end
  helper_method :current_character
  
  # Returns the currently active_profile or nil if there isn't one.
  def current_profile
    return unless profile_active?
    if defined? session[:profile_type].constantize
      @current_profile ||= session[:profile_type].constantize.find_by_id(session[:profile_id])
    end   
  end    
  helper_method :current_profile

  def locales
    locales = [
      { :locale => 'en-us', :language => 'American English' },
      { :locale => 'pirate', :language => 'Pirate' },
      { :locale => 'zombie', :language => 'Zombie' }]
    locales.each do |locale|
      locale[:is_current] = I18n.locale.to_s == locale[:locale] ? true : false
    end 
  end
  helper_method :locales

  def set_locale
    if(I18n.locale != params[:locale])
      I18n.locale = params[:locale] unless params[:locale].blank?
      redirect_to :back unless params[:locale].blank?
    else
      I18n.locale = params[:locale] unless params[:locale].blank?
    end
  end
  
  # Returns the currently logged in user or nil if there isn't one 
  def current_user
    #
    #return unless session[:user_id]
    #@current_user ||= User.find_by_id(session[:user_id])
    #cookies!
    session[:user_id] = cookies.signed[:remember_token] if not session[:user_id] and cookies.signed[:remember_token] 
    return unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    #@current_user ||= User.find_by_id(cookies.signed[:remember_token]) if cookies.signed[:remember_token]
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
  
  def access_denied
    session[:pre_login_url] = request.env["REQUEST_URI"] 
    redirect_to root_path, :alert => "Please log in to continue" and return false 
  end
  
  # Varibles for navigation
  def dynamic_discussions
    if session[:profile_type] =~ /Character$/
      if defined? session[:profile_type].constantize
        @character_profile ||= session[:profile_type].constantize.find_by_id(session[:profile_id]) 
        if @character_profile
          return nav_discussions.delete_if {|discussion_space| (discussion_space.game_id != nil and @character_profile.game_id != discussion_space.game_id)}
        end
      end
    end
    nav_discussions
  end
  helper_method :dynamic_discussions
  
  # This is used by dynamic_discussions. Use the dynamic_discussions method for the collection of discussion spaces.
  def nav_discussions
    DiscussionSpace.only_real_ones.delete_if {|discussion_space| (logged_in? and !current_user.can_show(discussion_space)) or !discussion_space.list_in_navigation}   
  end
  
  def dynamic_page_spaces
    if session[:profile_type] =~ /Character$/
      if defined? session[:profile_type].constantize
        @character_profile ||= session[:profile_type].constantize.find_by_id(session[:profile_id]) 
        if @character_profile
          return nav_page_spaces.delete_if {|page_space| (page_space.game_id != nil and @character_profile.game_id != page_space.game_id)}
        end
      end
    end
    nav_page_spaces
  end
  helper_method :dynamic_page_spaces
  
  def nav_page_spaces
    PageSpace.all.delete_if {|page_space| !page_space.check_user_show_permissions(current_user)}
  end 
  
  def nav_featured_pages
    Page.featured_pages.alphabetical
  end
  
  helper_method :nav_featured_pages
  
  # Returns the currently active theme folder name
  def current_theme
    return @theme = 'swtor-prime'
  end
  helper_method :current_theme
  
  def render_404
    redirect_to [request.protocol, request.domain, request.port_string, "/status_code/404"].join 
  end
  helper_method :render_404
  
  def render_insufficient_privileges
    render_404
  end
  helper_method :render_insufficient_privileges
  
  def collect_management_navigation_items
    @management_items = Array.new()
    return true unless logged_in?
    #application
    @management_items << {:link => management_registration_applications_path, :title => "Applications"} if current_user.can_manage("RegistrationApplication")
    #user
    @management_items << {:link => management_users_path, :title => "Users"} if current_user.can_manage("User")
    #roles
    @management_items << {:link => management_roles_path, :title => "Roles"} if current_user.can_manage("Role")
    #forms
    @management_items << {:link => management_site_forms_path, :title => "Forms"} if current_user.can_manage("SiteForm")
  end
  
end
