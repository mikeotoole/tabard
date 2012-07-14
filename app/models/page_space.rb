###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a page space.
###
class PageSpace < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  MAX_NAME_LENGTH = 30

###
# Attribute accessible
###
  attr_accessible :name, :supported_game_id, :supported_game

###
# Associations
###
  belongs_to :supported_game
  belongs_to :community
  has_many :pages, :dependent => :destroy, :order => 'LOWER(name)'

###
# Validators
###
  validates :name,  :presence => true,
                    :length => { :maximum => MAX_NAME_LENGTH }
  validates :community, :presence => true

###
# Delegates
###
  delegate :name, :to => :community, :prefix => true
  delegate :smart_name, :to => :supported_game, :prefix => true, :allow_nil => true

  after_create :apply_default_permissions

###
# Public Methods
###

###
# Instance Methods
###
  # This is the game
  def game
    if self.supported_game
      self.supported_game.game
    else
      nil
    end
  end

  # This is the game name
  def game_name
    self.supported_game_smart_name
  end

  ###
  # This method checks to see if this page space exists in a game context.
  # [Returns] True if space has game context. False otherwise.
  ###
  def has_game_context?
    self.supported_game_id != nil
  end

  # This method applys default permissions when this is created.
  def apply_default_permissions
    self.community.apply_default_permissions(self)
  end
end






# == Schema Information
#
# Table name: page_spaces
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  supported_game_id :integer
#  community_id      :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  deleted_at        :datetime
#

