###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a page space.
###
class PageSpace < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :name, :game_id

###
# Associations
###
  belongs_to :game
  belongs_to :community
  has_many :pages, :dependent => :destroy

###
# Validators
###
  validates :name, :presence => true
  validates :community, :presence => true

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method checks to see if this page space exists in a game context.
  # [Returns] True if space has game context. False otherwise.
  ###
  def has_game_context?
    self.game_id != nil
  end

  ###
  # This method gets the name of the game this page space belongs to, if it has
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
end

# == Schema Information
#
# Table name: page_spaces
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  user_profile_id :integer
#  game_id         :integer
#  community_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#

