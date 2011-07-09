require 'digest/sha1'
class User < ActiveRecord::Base
  attr_accessor :password
  
  validates :email, :uniqueness => true,
                    :length => { :within => 5..50 },
                    :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true, 
                    :length => { :within => 4..20 },
                    :presence => true, 
                    :if => :password_required?
                    
  has_one :user_profile, :autosave => true
  has_many :game_profiles, :through => :user_profile
  
  has_many :roles_users
  has_many :roles, :through => :roles_users
  
  before_save :encrypt_new_password, :update_lowercase_email
  
  accepts_nested_attributes_for :user_profile
  
  def sent_messages
    self.user_profile.sent_messages
  end
  
  def received_messages
    self.user_profile.received_messages
  end
  
  def deleted_received_messages
    self.user_profile.deleted_received_messages
  end
  
  def inbox
    self.user_profile.inbox
  end
  
  def folders
    self.user_profile.folders
  end
  
  def owns(resource)
    resource.respond_to?('owned_by_user') ? resource.owned_by_user(self) : false
  end
  
  def set_active_profile(profile)
    #profile.active = true
    #profile.save
  end
  
  def active_profile_helper_collection
    (Array.new() << (user_profile)).concat(characters)
  end
  
  def characters
    self.user_profile.characters
  end
 
  def all_game_profiles
    self.user_profile.game_profiles if user_profile
  end
  
  def user_profile_id
    user_profile.id
  end
  
  #TODO should the email never be returned for privacy?
  def name
    user_profile != nil ? user_profile.name : email
  end
  
  def status_string
    self.user_profile.status_string
  end
  
  def is_inactive
    self.user_profile.is_inactive
  end
  
  def self.authenticate(email, password) 
    user = find_by_lowercase_email(email.downcase)
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
    logger.debug("Show permission request for user #{self.name} with #{system_resource_name}")
    return false if not self.user_profile.is_active 
    if(system_resource_name.respond_to?('check_user_show_permissions'))
      if(system_resource_name.check_user_show_permissions(self))
        return true
      end
    end
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
    false
  end
  
  def can_create(system_resource_name)
    logger.debug("Create permission request for user #{self.name} with #{system_resource_name}")
    return false if not self.user_profile.is_active 
    if(system_resource_name.respond_to?('check_user_create_permissions'))
      if(system_resource_name.check_user_create_permissions(self))
        return true
      end
    end
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
    false
  end
  
  def can_manage(system_resource_name)
  	self.can_create(system_resource_name) or self.can_update(system_resource_name) or self.can_delete(system_resource_name)
  end
  
  def can_update(system_resource_name)
    logger.debug("Update permission request for user #{self.name} with #{system_resource_name}")
    return false if not self.user_profile.is_active 
    if(system_resource_name.respond_to?('check_user_update_permissions'))
      if(system_resource_name.check_user_update_permissions(self))
        return true
      end
    end
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
    false
  end
  
  def can_delete(system_resource_name)
    logger.debug("Delete permission request for user #{self.name} with #{system_resource_name}")
    return false if not self.user_profile.is_active
    if(system_resource_name.respond_to?('check_user_delete_permissions'))
      if(system_resource_name.check_user_delete_permissions(self))
        return true
      end
    end 
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
    false
  end
  
  def can_special_permissions(system_resource_name,permission_string)
    logger.debug("Special permission request (#{permission_string}) for user #{self.name} with #{system_resource_name}")
    return false if not self.user_profile.is_active 
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
    
    def update_lowercase_email
      self.lowercase_email = self.email.downcase
    end
    
    def encrypt(string) 
      Digest::SHA1.hexdigest(string)
    end
end
