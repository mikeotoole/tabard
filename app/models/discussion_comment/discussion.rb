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
  attr_accessible :name, :body, :comments_enabled, :has_been_locked

###
# Associations
###
  belongs_to :user_profile
  belongs_to :character_proxy
  belongs_to :discussion_space
  has_many :comments, :as => :commentable
  has_one :community, :through => :discussion_space

###
# Validators
###
  validates :name, :presence => true
  validates :body, :presence => true
  validates :user_profile, :presence => true
  validates :discussion_space, :presence => true  

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
#

