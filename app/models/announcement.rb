###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an actvity.
###
class Announcement < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

  scope :ordered, :order => 'created_at DESC'
  scope :recent, lambda { where("acknowledgements.created_at > ?", 2.weeks.ago) }

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
  attr_accessible :name, :body, :character_proxy_id, :is_locked, :has_been_edited, :supported_game, :supported_game_id, :comments_enabled

  # This is a virtual attribute to determine if comments are enabled.
  attr_accessor :comments_enabled

###
# Associations
###
  belongs_to :user_profile
  belongs_to :character_proxy
  belongs_to :community
  belongs_to :supported_game
  has_many :acknowledgements, :dependent => :destroy
  has_many :has_been_viewed_acknowledgements, :class_name => "Acknowledgement", :conditions => {:has_been_viewed => true}
  has_many :community_profiles_have_seen, :through => :has_been_viewed_acknowledgements, :source => "community_profile"
  has_many :user_profiles_have_seen, :through => :community_profiles_have_seen, :source => "user_profile"
  has_many :has_not_been_viewed_acknowledgements, :class_name => "Acknowledgement", :conditions => {:has_been_viewed => false}
  has_many :community_profiles_have_not_seen, :through => :has_not_been_viewed_acknowledgements, :source => "community_profile"
  has_many :user_profiles_have_not_seen, :through => :community_profiles_have_not_seen, :source => "user_profile"
  has_many :comments, :as => :commentable
  has_many :all_comments, :as => :original_commentable, :class_name => "Comment"

###
# Validators
###
  validates :name, :presence => true, :length => { :maximum => MAX_NAME_LENGTH }
  validates :body, :length => { :maximum => MAX_BODY_LENGTH }
  validates :user_profile, :presence => true
  validates :community, :presence => true
  validate :character_is_valid_for_user_profile
  validate :character_is_valid_for_supported_game

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :prefix => true, :allow_nil => true
  delegate :name, :to => :community, :prefix => true, :allow_nil => true
  delegate :subdomain, :to => :community, :allow_nil => true
  delegate :name, :to => :poster, :prefix => true, :allow_nil => true
  delegate :smart_name, :to => :supported_game, :prefix => true, :allow_nil => true

  before_destroy :destroy_all_comments
  after_create :create_acknowledgements
  before_save :update_is_locked_from_comments_enabled

  scope :non_community, where(Announcement.arel_table[:supported_game_id].not_eq(nil))

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

  #This method finds the correct name.
  def context_name
    if self.supported_game
      return self.supported_game.smart_name
    else
      return "#{self.community_name} Announcements"
    end
  end

  ###
  # This method checks to see if a character posted this discussion.
  # [Returns] True if a character made this discussion, otherwise false.
  ###
  def charater_posted?
    self.character_proxy != nil
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
    community_profile = some_user_profile.community_profiles.where(:community_id => self.community.id).first
    acknowledgment = self.acknowledgements.where(:community_profile_id => community_profile.id).first if community_profile
    acknowledgment.update_attributes({:has_been_viewed => true}) if acknowledgment
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
    return unless self.character_proxy
    self.errors.add(:character_proxy_id, "this character is not owned by you") unless self.user_profile.character_proxies.include?(self.character_proxy)
  end

  ###
  # This method validates that the selected character is valid for the community.
  ###
  def character_is_valid_for_supported_game
    return unless self.character_proxy
    unless self.character_proxy.compatable_with_supported_game?(self.supported_game)
      self.errors.add(:character_proxy_id, "this character is not compatable with the selected context")
      self.errors.add(:supported_game_id, "this context is not compatable with the selected character")
    end
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
    Comment.where(:original_commentable_id => self.id, :original_commentable_type => 'Discussion').update_all(:deleted_at => Time.now)
  end

  ###
  # _after_create_
  #
  # Destroys all comments
  ###
  def create_acknowledgements
    if self.supported_game
      self.community.community_profiles.delete_if{|profile| !profile.has_character_that_matches_supported_game(self.supported_game)}.each do |community_profile|
        community_profile.acknowledgements.create(:announcement => self, :has_been_viewed => community_profile.user_profile_id == self.user_profile_id ? true : false)
      end
    else
      self.community.community_profiles.each do |community_profile|
        community_profile.acknowledgements.create(:announcement => self, :has_been_viewed => community_profile.user_profile_id == self.user_profile_id ? true : false)
      end
    end
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
# Table name: announcements
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  body               :text
#  character_proxy_id :integer
#  user_profile_id    :integer
#  community_id       :integer
#  supported_game_id  :integer
#  is_locked          :boolean         default(FALSE)
#  deleted_at         :datetime
#  has_been_edited    :boolean         default(FALSE)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

