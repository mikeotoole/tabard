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
  attr_accessible :body, :commentable_id, :commentable_type, :has_been_deleted, :has_been_edited, :has_been_locked

###
# Attribute accessor
###  
  ###
  # This attribute is for javascript to let a comment know what dom element is the target for the comment form after a comment has been submitted.
  ###
  attr_accessor :form_target

  ###
  # This attribute is for javascript to let a comment know what dom element is the target for the comment when it created.
  ###
  attr_accessor :comment_target

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
# Validators
###
  validates :body, :presence => true
  validates :user_profile, :presence => true
  validates :community, :presence => true
  validates :commentable, :presence => true  

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
   temp_total_num_comments = 1
   comments.each do |comment|
     temp_total_num_comments += comment.number_of_comments
   end
   temp_total_num_comments
  end

  ###
  # This method returns an array of HTML classes that should be be applied to this comment.
  # [Returns] An array of HTML classes.
  ###
  def html_classes
    html_classes = Array.new()
    html_classes << 'locked' if has_been_locked
    html_classes << 'edited' if has_been_edited
    html_classes
  end

  ###
  # This method returns the original item that this comment is attached to, climbing the comment tree if needed.
  # [Returns] The original comment item.
  ###
  def original_comment_item
    (commentable.respond_to?('original_comment_item')) ? commentable.original_comment_item : commentable
  end

  ###
  # This method checks to see if replys to this comment are allowed.
  # [Returns] True if replys are allowed for this comment, otherwise false.
  ###
  def replys_locked?
    self.has_been_locked or 
        !self.original_comment_item.comments_enabled? or 
        (self.original_comment_item.respond_to?('has_been_locked') and self.original_comment_item.has_been_locked)
  end

  # The commentable_type always needs to be of the base class type and not the subclass type.
  def commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
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
  def get_community_id_from_source
    return if self.community or not self.commentable_id
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

