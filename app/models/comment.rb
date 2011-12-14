###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a comment.
###
class Comment < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :body, :commentable_id, :commentable_type, :is_removed, :has_been_edited, :is_locked, :character_proxy_id, :community

###
# Associations
###
  belongs_to :user_profile
  belongs_to :character_proxy
  belongs_to :community
  belongs_to :commentable, :polymorphic => true
  belongs_to :original_commentable, :polymorphic => true
  has_many :comments, :as => :commentable

###
# Scopes
###
  scope :not_deleted, where(:is_removed => false)
  scope :ordered, :order => "updated_at DESC"

###
# Callbacks
###
  after_initialize :get_community_id_from_source
  before_create :set_original_commentable

###
# Delegates
###
  delegate :name, :to => :community, :prefix => true
  delegate :subdomain, :to => :community, :prefix => true
  delegate :admin_profile_id, :to => :community, :prefix => true
  delegate :display_name, :to => :user_profile, :prefix => true
  delegate :created_at, :to => :user_profile, :prefix => true
  delegate :body, :to => :commentable, :prefix => true, :allow_nil => true
  delegate :name, :to => :poster, :prefix => true, :allow_nil => true

###
# Validators
###
  validates :body, :presence => true
  validates :user_profile, :presence => true
  validates :community, :presence => true
  validates :commentable, :presence => true
  validate :character_is_valid_for_user_profile
  validate :replys_enabled

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method gets the poster of this comment. If character proxy is not nil
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
  # This method checks to see if a character posted this comment.
  # [Returns] True if a character made this comment, otherwise false.
  ###
  def charater_posted?
    character_proxy != nil
  end

  ###
  # This method returns the total number of comments that this comment has, including itself.
  # [Returns] An integer that contains the number of comments this comment has including itself.
  ###
  def number_of_comments
    total_num_comments = self.is_removed ? 0 : 1
    self.comments.each do |comment|
      total_num_comments += comment.number_of_comments
    end
    total_num_comments
  end

  ###
  # This method checks to see if replies to this comment are allowed.
  # [Returns] True if replies are allowed for this comment, otherwise false.
  ###
  def replies_locked?
    self.is_locked or self.commentable_has_comments_disabled?
  end

  ###
  # This method validates that what the comment is commenting on allows replys.
  ###
  def replys_enabled
    return unless self.commentable_has_comments_disabled?
    self.errors.add(:base, "you can't reply to that!")
  end

  ###
  # Overrides the default destory
  # This will only delete the comment if it has no comments. If it has comments it will be marked is_removed and it's body will be cleared.
  def destroy
    if self.comments.empty?
      self.delete
    else
      self.is_removed = true
      self.body = ""
      self.save(:validate => false)
    end
  end

###
# Setter Methods
###
  # The commentable_type always needs to be of the base class type and not the subclass type.
  def commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end

  # The original_commentable_type always needs to be of the base class type and not the subclass type.
  def original_commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end

  ###
  # This method checks to see if comments are disabled for the commentable item.
  # [Returns] false if what this is commenting on has comments disabled.
  ###
  def commentable_has_comments_disabled?
    (self.commentable.respond_to?('replies_locked?') and self.commentable.replies_locked?) or
    (self.original_commentable.respond_to?('is_locked') and self.original_commentable.is_locked)
  end

###
# Protected Methods
###
protected

###
# Instance Methods
###

###
# Validator Methods
###
  ###
  # This method validates that the selected game is valid for the community.
  ###
  def character_is_valid_for_user_profile
    return unless self.character_proxy
    self.errors.add(:character_proxy_id, "this character is not owned by you") unless self.user_profile.character_proxies.include?(self.character_proxy)
  end

###
# Callback Methods
###
  ###
  # _before_create_
  #
  # This method will get and use the community of the item that this comment is attached to, if possible.
  # [Returns] False if an error was encountered, otherwise true.
  ###
  def get_community_id_from_source
    return if self.community_id or not self.commentable_id
    if self.commentable.respond_to?('community')
      self.community = self.commentable.community
    elsif self.original_commentable.respond_to?('community')
      self.community = self.original_commentable.community
    end
  end

  ###
  # _before_create_
  #
  # This method will get the original_commentable from the commentable.
  # [Returns] False if an error was encountered, otherwise true.
  ###
  def set_original_commentable
    return if self.original_commentable_id or not self.commentable_id
    if self.commentable.respond_to?('original_commentable')
      self.original_commentable = self.commentable.original_commentable
    else
      self.original_commentable = self.commentable
    end
  end
end








# == Schema Information
#
# Table name: comments
#
#  id                        :integer         not null, primary key
#  body                      :text
#  user_profile_id           :integer
#  character_proxy_id        :integer
#  community_id              :integer
#  commentable_id            :integer
#  commentable_type          :string(255)
#  is_removed                :boolean         default(FALSE)
#  has_been_edited           :boolean         default(FALSE)
#  is_locked                 :boolean         default(FALSE)
#  created_at                :datetime
#  updated_at                :datetime
#  original_commentable_id   :integer
#  original_commentable_type :string(255)
#

