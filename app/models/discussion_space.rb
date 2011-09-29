###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a discussion space.
###
class DiscussionSpace < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :name, :game

###
# Associations
###
  belongs_to :user_profile
  belongs_to :game
  belongs_to :community
  has_many :discussions, :dependent => :destroy

###
# Validators
###
  validates :name, :presence => true
  validates :user_profile, :presence => true
  validates :community, :presence => true

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method checks to see if this discussion sapce exists in a game context.
  # [Returns] True if space has game context. False otherwise.
  ###
  def has_game_context?
    self.game_id != nil
  end

  ###
  # This method gets the name of the game this discussion space belongs to, if it has
  # one. If it is not associated with a game an empty string is returned.
  # [Returns] The game that this discussion space belongs to, otherwise empty string.
  ###
  def game_name
    if self.game
      self.game.name
    else
      ''
    end
  end

  ###
  # This method gets the user profile name of the creator of this discussion space
  # [Returns] The display name of the user profile that created this discussion space.
  ###
  def creator_name
    user_profile.display_name if user_profile
  end
end


# == Schema Information
#
# Table name: discussion_spaces
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  user_profile_id :integer
#  game_id         :integer
#  community_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  is_announcement :boolean         default(FALSE)
#

