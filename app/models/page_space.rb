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
  attr_accessible :name, :supported_game_id

###
# Associations
###
  belongs_to :supported_game
  belongs_to :community
  has_many :pages, :dependent => :destroy

###
# Validators
###
  validates :name,  :presence => true, 
                    :length => { :maximum => 100 }
  validates :community, :presence => true

###
# Delegates
###
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  delegate :name, :to => :community, :prefix => true
  delegate :full_name, :to => :supported_game, :prefix => true, :allow_nil => true

  after_create :apply_default_permissions

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
#  created_at        :datetime
#  updated_at        :datetime
#

