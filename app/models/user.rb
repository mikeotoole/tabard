require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  
  validates :email, :uniqueness => true,
                    :length => { :within => 5..50 },
                    :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true, 
                    :length => { :within => 4..20 },
                    :presence => true, 
                    :if => :password_required?
                    
  has_one :user_profile
  has_many :game_profiles, :through => :user_profile
  
  has_and_belongs_to_many :roles
  
  before_save :encrypt_new_password
  
  def owns(resource)
    resource.respond_to?('owned_by_user') ? resource.owned_by_user : false
  end
  
  def profiles
    (Array.new() << (user_profile)).concat(game_profiles)
  end
  
  def active_profile_helper_collection
    (Array.new() << (user_profile)).concat(characters)
  end
  
  #TODO This needs to change for the new character model
  def add_character(character, default)  
    @gameprofiles = self.all_game_profiles
    if @gameprofiles
      @profile = @gameprofiles.find(:first, :conditions => { :game_id => character.game_id })
    else
      exit errors.add "User has no user profile!"
    end
    if @profile == nil
      @profile = GameProfile.create(:game_id => character.game_id, :user_profile => self.user_profile)
      @profile.default_character = character
      @profile.save
    elsif default
      @profile.default_character = character
      @profile.save
    end
    character.game_profile = @profile
    character.save
  end
  
  def characters
    self.user_profile.characters
  end
 
  # def all_game_profiles
  #   self.user_profile.game_profiles if user_profile
  # end
  
  def user_profile_id
    user_profile.id
  end
  
  #TODO should this return email if user_profile.name is blank?
  def name
    user_profile != nil ? user_profile.name : email
  end
  
  def self.authenticate(email, password) 
    user = find_by_email(email)
    return user if user && user.authenticated?(password)
  end
  
  def authenticated?(password) 
    self.hashed_password == encrypt(password)
  end
  
  # Returns a collection of the currently logged in users unacknowledged announcements or nil if empty.
  def unacknowledged_announcements
      @userprofile = UserProfile.find(:first, :conditions => {:user_id => self.id})
      @profiles = GameProfile.find(:all, :conditions => {:user_profile_id => @userprofile.id})
      @profiles << @userprofile
      @acknowledgment_of_announcements = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:acknowledged => false, :profile_id => @profiles})
      @acknowledgment_of_announcements
  end
  
  #need to add clause for if the user owns the resource
  def can_show(system_resource_name)
    self.roles.each do |role|
      if(role.show_permissionables.include?(system_resource_name))
        return true
      end
      role.show_system_resources.each do |s_resource|
        if(s_resource.permissionable_name == system_resource_name)
          return true
        end
      end
    end
    if(system_resource_name.respond_to?('check_user_show_permissions'))
      if(system_resource_name.check_user_show_permissions(self))
        return true
      end
    end
    false
  end
  
  def can_create(system_resource_name)
    self.roles.each do |role|
      if(role.create_permissionables.include?(system_resource_name))
        return true
      end
      role.create_system_resources.each do |s_resource|
        if(s_resource.permissionable_name == system_resource_name)
          return true
        end
      end
    end
    if(system_resource_name.respond_to?('check_user_create_permissions'))
      if(system_resource_name.check_user_create_permissions(self))
        return true
      end
    end
    false
  end
  
  def can_update(system_resource_name)
    self.roles.each do |role|
      if(role.update_permissionables.include?(system_resource_name))
        return true
      end
      role.update_system_resources.each do |s_resource|
        if(s_resource.permissionable_name == system_resource_name)
          return true
        end
      end
    end
    if(system_resource_name.respond_to?('check_user_update_permissions'))
      if(system_resource_name.check_user_update_permissions(self))
        return true
      end
    end
    false
  end
  
  def can_delete(system_resource_name)
    self.roles.each do |role|
      if(role.delete_permissionables.include?(system_resource_name))
        return true
      end
      role.delete_system_resources.each do |s_resource|
        if(s_resource.permissionable_name == system_resource_name)
          return true
        end
      end
    end
    if(system_resource_name.respond_to?('check_user_delete_permissions'))
      if(system_resource_name.check_user_delete_permissions(self))
        return true
      end
    end
    false
  end
  
  def can_special_permissions(system_resource_name,permission_string)
    permissionable_id = SystemResource.where(:name => system_resource_name).first.id if SystemResource.where(:name => system_resource_name).exists?
    if !permissionable_id
      return false
    end
    corrected_permission = "%"<<permission_string<<"%"
    self.roles.each do |role|
      if(role.special_permissionables.where("access like ? and permissionable_type = 'SystemResource' and permissionable_id = ?", 
        corrected_permission, 
        permissionable_id).exists?
      )
        return true
      end
    end
    false
  end
  
  protected 
    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password) 
    end
  
    def password_required? 
      hashed_password.blank? || password.present?
    end
    def encrypt(string) 
      Digest::SHA1.hexdigest(string)
    end
end
