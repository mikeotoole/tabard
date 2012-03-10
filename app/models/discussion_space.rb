###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a discussion space.
###
class DiscussionSpace < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  # Used by the validator. Needs to be extra long to allow announcment spacee names using full game name.
  MAX_NAME_LENGTH = 150
  # Used buy the view to limit the number of characters a user can enter.
  MAX_NAME_LENGTH_VIEW = 30

###
# Attribute accessible
###
  attr_accessible :name, :supported_game_id, :supported_game

###
# Associations
###
  belongs_to :supported_game
  belongs_to :community
  has_many :discussions, :dependent => :destroy

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
  after_create :remove_action_item

###
# Public Methods
###

###
# Class Methods
###
  def self.destory_discussion_space(id)
    discussion_space = DiscussionSpace.with_deleted.find(id)
    discussion_space.discussions.destroy_all
  end

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
  
  def game_name
    self.supported_game_smart_name
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

  # This is a class method to destory a DiscussionSpace using delay job.
  def delay_destory
    self.update_attribute(:deleted_at, Time.now) # Set deleted_at to current time so space is not visable.
    DiscussionSpace.delay.destory_discussion_space(self.id)
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _after_create_
  #
  # This method applys default permissions when this is created.
  ###
  def apply_default_permissions
    return if self.is_announcement_space
    self.community.apply_default_permissions(self)
  end

  ###
  # _after_create_
  #
  # This method removes action item from community.
  ### 
  def remove_action_item
    if self.community.action_items.any?
      self.community.action_items.delete(:create_discussion_space)
      self.community.save
    end
  end
end





# == Schema Information
#
# Table name: discussion_spaces
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  supported_game_id     :integer
#  community_id          :integer
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  is_announcement_space :boolean         default(FALSE)
#  deleted_at            :datetime
#

