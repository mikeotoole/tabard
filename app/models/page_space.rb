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
  attr_accessible :name, :game_id, :game_type

###
# Associations
###
  belongs_to :supported_game
  belongs_to :community
  has_many :pages, :dependent => :destroy

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
  # This method checks to see if this page space exists in a game context.
  # [Returns] True if space has game context. False otherwise.
  ###
  def has_game_context?
    self.supported_game_id != nil
  end
end

# == Schema Information
#
# Table name: page_spaces
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  supported_gam:integer
#  community_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

