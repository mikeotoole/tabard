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
  attr_accessible :name, :supported_game_id

###
# Associations
###
  belongs_to :supported_game
  belongs_to :community
  has_many :discussions, :dependent => :destroy

###
# Validators
###
  validates :name, :presence => true
  validates :community, :presence => true

###
# Delegates
###
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  delegate :name, :to => :community, :prefix => true
  delegate :full_name, :to => :supported_game, :prefix => true, :allow_nil => true

###
# Public Methods
###

###
# Instance Methods
###

  def game
    if self.supported_game
      self.supported_game.game
    else
      nil
    end
  end

  ###
  # This method checks to see if this discussion sapce exists in a game context.
  # [Returns] True if space has game context. False otherwise.
  ###
  def has_game_context?
    self.supported_game_id != nil
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
#  id                :integer         not null, primary key
#  name              :string(255)
#  supported_game_id :integer
#  community_id      :integer
#  created_at        :datetime
#  updated_at        :datetime
#  is_announcement   :boolean         default(FALSE)
#

