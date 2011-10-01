###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a discussion.
###
class Discussion < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :name, :body, :character_proxy_id, :comments_enabled, :has_been_locked

###
# Associations
###
  belongs_to :user_profile
  belongs_to :character_proxy
  belongs_to :discussion_space
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_one :community, :through => :discussion_space
  has_many :view_logs, :as => :view_loggable

###
# Validators
###
  validates :name, :presence => true
  validates :body, :presence => true
  validates :user_profile, :presence => true
  validates :discussion_space, :presence => true
  validate :character_is_valid_for_user_profile

###
# Delegates
###
  delegate :is_announcement, :to => :discussion_space, :allow_nil => true

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method gets the poster of this discussion. If character proxy is not nil
  # the character is returned. Otherwise the user profile is returned. These should
  # both respond to a common interface for things like display name and avatar.
  # [Returns] The poster, A character or user profile.
  ###
  def poster
    if self.character_proxy
      self.character_proxy.character
    else
      self.user_profile
    end
  end

  ###
  # This method checks to see if a character posted this discussion.
  # [Returns] True if a character made this discussion, otherwise false.
  ###
  def charater_posted?
    character_proxy != nil
  end

  ###
  # This method determines how many comments have been made regarding this discussion.
  # [Returns] An integer that contains how many comments have been made for this discussion, including comments on a comment (recursivly).
  ###
  def number_of_comments
   temp_total_num_comments = 0
   comments.each do |comment|
     temp_total_num_comments += comment.number_of_comments
   end
   temp_total_num_comments
  end

  ###
  # This will updated the view log for this discussion. If a view log exists for the user profile its modifyed date
  # will be updated. Otherwise a new view log is created.
  # [Args]
  #   * +user_profile+ The profile of the user that viewed the discussion.
  ###
  def update_viewed(user_profile)
    log = self.view_logs.find_by_user_profile_id(user_profile.id)
    if log
      log.touch
    else
      log = self.view_logs.new()
      log.user_profile = user_profile
      log.view_loggable = self
      log.save
    end
  end

  ###
  # This method validates that the selected game is valid for the community.
  ###
  def character_is_valid_for_user_profile
    return unless self.character_proxy
    self.errors.add(:character_proxy_id, "this character is not owned by you") unless self.user_profile.character_proxies.include?(self.character_proxy)
  end
end


# == Schema Information
#
# Table name: discussions
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  body                :text
#  discussion_space_id :integer
#  character_proxy_id  :integer
#  user_profile_id     :integer
#  comments_enabled    :boolean         default(TRUE)
#  has_been_locked     :boolean         default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#  is_archived         :boolean         default(FALSE)
#

