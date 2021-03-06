###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a discussion.
###
class Discussion < ActiveRecord::Base
  validates_lengths_from_database except: [:name, :body]
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

  scope :ordered, order: 'created_at DESC'
###
# Constants
###
  # This is the max name length
  MAX_NAME_LENGTH = 60
  # This is the max body length
  MAX_BODY_LENGTH = 10000

###
# Attribute accessible
###
  attr_accessible :name, :body, :character_id, :is_locked, :has_been_edited, :comments_enabled

  # This is a virtual attribute to determine if comments are enabled.
  attr_accessor :comments_enabled

###
# Associations
###
  belongs_to :user_profile
  belongs_to :character
  belongs_to :discussion_space
  has_many :comments, as: :commentable
  has_many :all_comments, as: :original_commentable, class_name: "Comment"
  has_one :community, through: :discussion_space
  has_many :view_logs, as: :view_loggable, dependent: :destroy

###
# Validators
###
  validates :name,  presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates :body, presence: true, length: { maximum: MAX_BODY_LENGTH }
  validates :user_profile, presence: true
  validates :discussion_space, presence: true
  validate :character_is_valid_for_user_profile

###
# Delegates
###
  delegate :name, to: :discussion_space, prefix: true, allow_nil: true
  delegate :game, to: :discussion_space, prefix: true, allow_nil: true
  delegate :game_name, to: :discussion_space, allow_nil: true
  delegate :admin_profile_id, to: :community, prefix: true, allow_nil: true
  delegate :name, to: :community, prefix: true, allow_nil: true
  delegate :subdomain, to: :community, allow_nil: true
  delegate :name, to: :user_profile, prefix: true, allow_nil: true
  delegate :name, to: :poster, prefix: true, allow_nil: true
  delegate :avatar_url, to: :poster, prefix: true, allow_nil: true

  before_destroy :destroy_all_comments
  before_save :update_is_locked_from_comments_enabled

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method gets the poster of this discussion. If character is not nil
  # the character is returned. Otherwise the user profile is returned. These should
  # both respond to a common interface for things like display name and avatar.
  # [Returns] The poster, A character or user profile.
  ###
  def poster
    if self.character
      self.character
    else
      self.user_profile
    end
  end

  ###
  # This method checks to see if a character posted this discussion.
  # [Returns] True if a character made this discussion, otherwise false.
  ###
  def charater_posted?
    self.character != nil
  end

  ###
  # This method determines how many comments have been made regarding this discussion.
  # [Returns] An integer that contains how many comments have been made for this discussion, including comments on a comment (recursivly).
  ###
  def number_of_comments
    self.all_comments.not_deleted.count
  end

  ###
  # This will update the view log for this discussion. If a view log exists for the user profile its modified date
  # will be updated. Otherwise a new view log is created.
  # [Args]
  #   * +user_profile+ The profile of the user that viewed the discussion.
  ###
  def update_viewed(some_user_profile)
    some_user_profile.update_viewed(self)
  end

  # This will destroy forever this discussion and all its comments.
  def nuke
    self.all_comments.each{|comment| comment.nuke}
    self.destroy!
  end

###
# Protected Methods
###
protected

###
# Validator Methods
###
  ###
  # This method validates that the selected character is valid for the community.
  ###
  def character_is_valid_for_user_profile
    return unless self.character
    self.errors.add(:character_id, "this character is not owned by you") unless self.user_profile.characters.include?(self.character)
  end


###
# Callback Methods
###
  ###
  # _before_destroy_
  #
  # Destroys all comments
  ###
  def destroy_all_comments
    Comment.where(original_commentable_id: self.id, original_commentable_type: 'Discussion').update_all(deleted_at: Time.now)
  end

  ###
  # _before_save_
  #
  # Sets the is_locked attribute based on the value of comments_enabled
  ###
  def update_is_locked_from_comments_enabled
    self.is_locked = true if comments_enabled == '0'
    self.is_locked = false if comments_enabled == '1'
    return true
  end
end

# == Schema Information
#
# Table name: discussions
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  body                :text
#  discussion_space_id :integer
#  character_proxy_id  :integer
#  user_profile_id     :integer
#  is_locked           :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  deleted_at          :datetime
#  has_been_edited     :boolean          default(FALSE)
#  character_id        :integer
#

