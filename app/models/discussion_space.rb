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
  attr_accessible :name, :game_id, :game_type

###
# Associations
###
  belongs_to :supported_game
  has_one :game, :through => :supported_game
  belongs_to :community
  has_many :discussions, :dependent => :destroy

###
# Validators
###
  validates :name, :presence => true
  validates :community, :presence => true
  validate :game_is_valid_for_community

###
# Delegates
###
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  delegate :name, :to => :community, :prefix => true

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
  # This method validates that the selected game is valid for the community.
  ###
  def game_is_valid_for_community
    return unless self.game
    self.errors.add(:game_id, "this game is not part of the community") unless self.community.games.map{|g| g.id}.include?(self.game.id)
  end

  ###
  # This method determines how many discussions are in this discussion space.
  # [Returns] An integer that contains how many discussions are in this discussion space.
  ###
  def number_of_discussions
    self.discussions.count
  end
end







# == Schema Information
#
# Table name: discussion_spaces
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  supported_game_i:integer
#  community_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  is_announcement :boolean         default(FALSE)
#

