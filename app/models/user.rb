require 'digest/sha1'
=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a user.
=end
class User < ActiveRecord::Base

=begin
  This attribute is for the user's un-encrypted password.
=end
  attr_accessor :password

=begin
  This attribute is a boolean that will prevent a signup email from being sent out if it is set to true.
=end
  attr_accessor :no_signup_email

  #attr_accessible :email, :password, :user_profile, :no_signup_email

  validates :email, :uniqueness => true,
                    :length => { :within => 5..50 },
                    :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true,
                    :length => { :within => 4..20 },
                    :presence => true,
                    :if => :password_required?

  # Associations
  has_one :user_profile, :autosave => true
  has_many :game_profiles, :through => :user_profile
  has_many :roles_users
  has_many :roles, :through => :roles_users
  has_many :announcements, :through => :user_profile

  before_save :encrypt_new_password, :update_lowercase_email

  accepts_nested_attributes_for :user_profile

=begin
  This method gets the user's sent messages.
  [Returns] An array that contains the user's sent messages through its user profile.
=end
  def sent_messages
    self.user_profile.sent_messages
  end

=begin
  This method gets the user's received messages.
  [Returns] An array that contains the user's received messages through its user profile.
=end
  def received_messages
    self.user_profile.received_messages
  end

=begin
  This method gets the user's deleted recieved messages.
  [Returns] An array that contains the user's deleted recieved messages through its user profile.
=end
  def deleted_received_messages
    self.user_profile.deleted_received_messages
  end

=begin
  This method gets the user's inbox.
  [Returns] The user's inbox folder through its user profile.
=end
  def inbox
    self.user_profile.inbox
  end

=begin
  This method gets the user's folders.
  [Returns] The user's folders through its user profile.
=end
  def folders
    self.user_profile.folders
  end

=begin
  This method checks to see if a user owns the object passed to it.
  [Args]
    * +resource+ -> The resource you would like to check for ownership.
  [Returns] True if the object passed to it responds true to "owned_by_user(self)", otherwise false.
=end
  def owns(resource)
    resource.respond_to?('owned_by_user') ? resource.owned_by_user(self) : false
  end

=begin
  This method gets the user's communities.
  [Returns] An array that contains the user's unique communities.
=end
  def communities
    self.roles.collect{|role|
      role.community
    }.uniq
  end

=begin
  This method checks to see if a user is a member of a community.
  [Args]
    * +community+ -> The community you would like to check.
  [Returns] True if the user has a role belonging to the community passed to it, otherwise false.
=end
  def is_a_member_of(community)
    self.communities.include?(community)
  end

=begin
  This method sets the active profile. *NOT USED*
  [Args]
    * +profile+ -> The profile to use.
=end
  def set_active_profile(profile)
    #profile.active = true
    #profile.save
  end

=begin
  This method gets an array of possible active profile options.
  [Returns] An array that user profile + all of their characters.
=end
  def active_profile_helper_collection
    (Array.new() << (user_profile)).concat(characters)
  end

=begin
  This method gets the user's characters.
  [Returns] The user's characters through its user profile.
=end
  def characters
    self.user_profile.characters
  end

=begin
  This method gets the user's game profiles.
  [Returns] The user's game profiles through its user profile.
=end
  def all_game_profiles
    self.user_profile.game_profiles
  end

=begin
  This method gets the user's user profile id.
  [Returns] An integer that contains the user's user profile id.
=end
  def user_profile_id
    self.user_profile.id
  end

=begin
  This method gets the name of the user if possible.
  [Returns] A string that contains the user's user profile name, if possible, otherwise "Anon".
=end
  def name
    user_profile != nil ? user_profile.name : "Anon"
  end

=begin
  This method gets the display name of the user.
  [Returns] A string that contains the user's user profile's display name.
=end
  def display_name
    self.user_profile.display_name if user_profile
  end

=begin
  This method gets all of the user's characters that belong to the specified game.
  [Args]
    * +game+ -> The game you would like to use.
  [Returns] An array of characters for this user for the specified game.
=end
  def get_characters(game)
    self.user_profile.get_characters(game)
  end

=begin
  This method gets all of the users that this user can message.
  [Returns] An array of users that this user can message.
=end
  def address_book
    communities = self.roles.collect{ |role| role.community }.uniq
    users = communities.collect{|community| community.all_users}.flatten.uniq
    users.collect{|user| user.user_profile}
  end

=begin
  This method attempts to return the user that corresponds to the provided credentials.
  [Args]
    * +email+ -> The email of the user.
    * +password+ -> The password of the user.
  [Returns] An array of characters for this user for the specified game.
=end
  def self.authenticate(email, password)
    user = find_by_lowercase_email(email.downcase)
    return user if user && user.authenticated?(password)
  end

=begin
  This method attempts to authenticate this user with the given password.
  [Args]
    * +password+ -> The password you would like to use.
  [Returns] True is the password provided is correct, otherwise false.
=end
  def authenticated?(password)
    self.hashed_password == encrypt(password)
  end

=begin
  This method attempts get all of this users unacknowledged acknowledgement_of_announcements.
  [Returns] An array that contains all of the this users acknowledgement_of_announcements that have not been acknowleged.
=end
  def unacknowledged_announcements
      @userprofile = UserProfile.find(:first, :conditions => {:user_id => self.id})
      @profiles = GameProfile.find(:all, :conditions => {:user_profile_id => @userprofile.id})
      @profiles << @userprofile
      @acknowledgment_of_announcements = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:acknowledged => false, :profile_id => @profiles})
      #@acknowledgment_of_announcements = Array.new
  end

=begin
  This method determines if the user can show the resource passed to it.
  [Args]
    * +system_resource_name+ -> A string that contains the name of the resource type, or the resource itself (must implement check_user_show_permissions(user)).
  [Returns] True is the user can show the resource, otherwise false.
=end
  def can_show(system_resource_name)
    if(system_resource_name.respond_to?('check_user_show_permissions'))
      if(system_resource_name.check_user_show_permissions(self))
        logger.debug("Show permission request for user #{self.name} with #{system_resource_name.to_s} | Pass")
        return true
      end
    end
    self.roles.each do |role|
      if(role.show_permissionables.include?(system_resource_name))
        logger.debug("Show permission request for user #{self.name} with #{system_resource_name} | Pass")
        return true
      end
      role.show_system_resources.each do |s_resource|
        if(s_resource.permissionable_name == system_resource_name)
          logger.debug("Show permission request for user #{self.name} with #{system_resource_name} | Pass")
          return true
        end
      end
    end
    logger.debug("Show permission request for user #{self.name} with #{system_resource_name.to_s} | Fail")
    false
  end

=begin
  This method determines if the user can create the resource passed to it.
  [Args]
    * +system_resource_name+ -> A string that contains the name of the resource type, or the resource itself (must implement check_user_create_permissions(user)).
  [Returns] True is the user can create the resource, otherwise false.
=end
  def can_create(system_resource_name)
    if(system_resource_name.respond_to?('check_user_create_permissions'))
      if(system_resource_name.check_user_create_permissions(self))
        logger.debug("Create permission request for user #{self.name} with #{system_resource_name.to_s} | Pass")
        return true
      end
    end
    self.roles.each do |role|
      if(role.create_permissionables.include?(system_resource_name))
        logger.debug("Create permission request for user #{self.name} with #{system_resource_name} | Pass")
        return true
      end
      role.create_system_resources.each do |s_resource|
        if(s_resource.permissionable_name == system_resource_name)
          logger.debug("Create permission request for user #{self.name} with #{system_resource_name} | Pass")
          return true
        end
      end
    end
    logger.debug("Create permission request for user #{self.name} with #{system_resource_name.to_s} | Fail")
    false
  end

=begin
  This method determines if the user can manage the resource passed to it.
  [Args]
    * +system_resource_name+ -> A string that contains the name of the resource type, or the resource itself.
  [Returns] True is the user can create or update or delete the resource, otherwise false.
=end
  def can_manage(system_resource_name)
    self.can_create(system_resource_name) or self.can_update(system_resource_name) or self.can_delete(system_resource_name)
  end

=begin
  This method determines if the user can update the resource passed to it.
  [Args]
    * +system_resource_name+ -> A string that contains the name of the resource type, or the resource itself (must implement check_user_update_permissions(user)).
  [Returns] True is the user can update the resource, otherwise false.
=end
  def can_update(system_resource_name)
    if(system_resource_name.respond_to?('check_user_update_permissions'))
      if(system_resource_name.check_user_update_permissions(self))
        logger.debug("Update permission request for user #{self.name} with #{system_resource_name.to_s} | Pass")
        return true
      end
    end
    self.roles.each do |role|
      if(role.update_permissionables.include?(system_resource_name))
        logger.debug("Update permission request for user #{self.name} with #{system_resource_name} | Pass")
        return true
      end
      role.update_system_resources.each do |s_resource|
        if(s_resource.permissionable_name == system_resource_name)
          logger.debug("Update permission request for user #{self.name} with #{system_resource_name} | Pass")
          return true
        end
      end
    end
    logger.debug("Update permission request for user #{self.name} with #{system_resource_name.to_s} | Fail")
    false
  end

=begin
  This method determines if the user can delete the resource passed to it.
  [Args]
    * +system_resource_name+ -> A string that contains the name of the resource type, or the resource itself (must implement check_user_delete_permissions(user)).
  [Returns] True is the user can delete the resource, otherwise false.
=end
  def can_delete(system_resource_name)
    if(system_resource_name.respond_to?('check_user_delete_permissions'))
      if(system_resource_name.check_user_delete_permissions(self))
        logger.debug("Delete permission request for user #{self.name} with #{system_resource_name.to_s} | Pass")
        return true
      end
    end
    self.roles.each do |role|
      if(role.delete_permissionables.include?(system_resource_name))
        logger.debug("Delete permission request for user #{self.name} with #{system_resource_name} | Pass")
        return true
      end
      role.delete_system_resources.each do |s_resource|
        if(s_resource.permissionable_name == system_resource_name)
          logger.debug("Delete permission request for user #{self.name} with #{system_resource_name} | Pass")
          return true
        end
      end
    end
    logger.debug("Delete permission request for user #{self.name} with #{system_resource_name.to_s} | Fail")
    false
  end

  def can_special_permissions(system_resource_name,permission_string)
    permissionable_id = SystemResource.where(:name => system_resource_name).first.id if SystemResource.where(:name => system_resource_name).exists?
    if !permissionable_id
      logger.debug("Special permission request (#{permission_string}) for user #{self.name} with #{system_resource_name} | Fail")
      return false
    end
    corrected_permission = "%"<<permission_string<<"%"
    self.roles.each do |role|
      if(role.special_permissionables.where("access like ? and permissionable_type = 'SystemResource' and permissionable_id = ?",
        corrected_permission,
        permissionable_id).exists?
      )
        logger.debug("Special permission request (#{permission_string}) for user #{self.name} with #{system_resource_name} | Pass")
        return true
      end
    end
    logger.debug("Special permission request (#{permission_string}) for user #{self.name} with #{system_resource_name} | Fail")
    false
  end

  protected
=begin
  _before_filter_

  This method automaticly encrypts the user's password, if the unencrypted password is not blank.
=end
    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end

=begin
  This method determines if the password is required. It is used to determine if password needs to be validated.
  [Returns] True if the hashed password is blank or if password is present, otherwise false.
=end
    def password_required?
      hashed_password.blank? || password.present?
    end

=begin
  _before_filter_

  This method automaticly lowercases the user's email.
=end
    def update_lowercase_email
      self.lowercase_email = self.email.downcase
    end

=begin
  This method encrypts the string passed to it.
  [Args]
    * +string+ -> The string you would like to encrypt.
  [Returns] A string that contains the encypted version of the string passed to this method.
=end
    def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  email           :string(255)
#  hashed_password :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  lowercase_email :string(255)
#

