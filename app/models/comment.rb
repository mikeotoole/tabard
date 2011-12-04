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
  attr_accessible :body, :commentable_id, :commentable_type, :has_been_deleted, :has_been_edited, :has_been_locked, :character_proxy_id, :community

###
# Associations
###
  belongs_to :user_profile
  belongs_to :character_proxy
  belongs_to :community
  belongs_to :commentable, :polymorphic => true
  has_many :comments, :as => :commentable

###
# Callbacks
###
  after_initialize :get_community_id_from_source

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :prefix => true
  delegate :id, :to => :user_profile, :prefix => true
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

  # TODO Mike, Replace me.
  ###
  # This method returns the total number of comments that this comment has, including itself.
  # [Returns] An integer that contains the number of comments this comment has including itself.
  ###
  def number_of_comments
    temp_total_num_comments = 0
   temp_total_num_comments = 1 unless self.has_been_deleted
   comments.each do |comment|
     temp_total_num_comments += comment.number_of_comments
   end
   temp_total_num_comments
  end

  # TODO Mike, Replace me.
  ###
  # This method gets all comments attacted to this comment. Even comments comments.
  # [Returns] A collection of comments.
  ###
  def all_comments
  temp_all_comments = Array.new
  temp_all_comments << self
   comments.each do |comment|
     temp_all_comments << comment.all_comments
   end
   temp_all_comments.flatten
  end

  # TODO Mike, Replace me.
  ###
  # This method returns the original item that this comment is attached to, climbing the comment tree if needed.
  # [Returns] The original comment item.
  ###
  def original_comment_item
    (commentable.respond_to?('original_comment_item')) ? commentable.original_comment_item : commentable
  end

  # TODO Mike, Update me.
  ###
  # This method checks to see if comments are disabled for the commentable item.
  # [Returns] false if what this is commenting on has comments disabled.
  ###
  def commentable_has_comments_disabled?
    (self.commentable.respond_to?('replies_locked?') and self.commentable.replies_locked?) or
    (self.commentable.respond_to?('comment_enabled?') and self.original_comment_item.comments_enabled?) or
    (self.original_comment_item.respond_to?('has_been_locked') and self.original_comment_item.has_been_locked)
  end

  ###
  # This method checks to see if replies to this comment are allowed.
  # [Returns] True if replies are allowed for this comment, otherwise false.
  ###
  def replies_locked?
    self.has_been_locked or self.commentable_has_comments_disabled?
  end

  # The commentable_type always needs to be of the base class type and not the subclass type.
  def commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end

  ###
  # This method validates that the selected game is valid for the community.
  ###
  def character_is_valid_for_user_profile
    return unless self.character_proxy
    self.errors.add(:character_proxy_id, "this character is not owned by you") unless self.user_profile.character_proxies.include?(self.character_proxy)
  end

  ###
  # This method validates that what the comment is commenting on allows replys.
  ###
  def replys_enabled
    return unless self.commentable_has_comments_disabled?
    self.errors.add(:base, "you can't reply to that!")
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_create_
  #
  # This method will get and use the community of the item that this comment is attached to, if possible.
  # [Returns] False if an error was encountered, otherwise true.
  ###
  def get_community_id_from_source # TODO Mike, Update me.
    return if self.community_id or not self.commentable_id
    if self.commentable.respond_to?('community')
      self.community = self.commentable.community
    elsif self.original_comment_item.respond_to?('community')
      self.community = self.original_comment_item.community
    end
  end
end


# == Schema Information
#
# Table name: comments
#
#  id                 :integer         not null, primary key
#  body               :text
#  user_profile_id    :integer
#  character_proxy_id :integer
#  community_id       :integer
#  commentable_id     :integer
#  commentable_type   :string(255)
#  has_been_deleted   :boolean         default(FALSE)
#  has_been_edited    :boolean         default(FALSE)
#  has_been_locked    :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

