###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This class represents a user's profile.
###
class UserProfile < ActiveRecord::Base
###
# Attribute Accessors
###
  ###
  # This attribute is the avatar for this user profile. It maps to the AvatarUploader.
  ###
  attr_accessor :avatar

  ###
  # This attribute is the avatar cache for this user profile. It is used by the AvatarUploader.
  ###
  attr_accessor :avatar_cache

  ###
  # This attribute is the avatar removal for this user profile. It is used by the AvatarUploader.
  ###
  attr_accessor :remove_avatar

###
# Associations
###
  belongs_to :user, :inverse_of => :user_profile
  has_many :owned_communities, :class_name => "Community", :foreign_key => "admin_profile_id"

###
# Delegates
###
  delegate :email, :to => :user

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

###
# Validators
###
  validates :first_name,
      :presence => true
  validates :last_name,
      :presence => true
  validates :user,
      :presence => true
  validates :avatar,
      :if => :avatar?,
      :file_size => {
        :maximum => 1.megabytes.to_i
      }

###
# Public Methods
###
  # This method returns the first name + space + last name
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

###
# Protected Methods
###
protected
  ###
  # This method is added for removing an avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
  ###
  def remove_avatar!
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
    end
  end

  ###
  # This method is added for removing a previously stored avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
  ###
  def remove_previously_stored_avatar
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
      @previous_model_for_avatar = nil
    end
  end
end

# == Schema Information
#
# Table name: user_profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  first_name :string(255)
#  last_name  :string(255)
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

