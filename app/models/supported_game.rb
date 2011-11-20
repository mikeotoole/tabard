###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an association between a game and a community that participates (supports) it.
###
class SupportedGame < ActiveRecord::Base
###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :game_id, :game_type

###
# Associations
###
  belongs_to :community
  belongs_to :game, :polymorphic => true
  belongs_to :game_announcement_space, :class_name => "DiscussionSpace", :dependent => :destroy

###
# Delegates
###
  delegate :name, :to => :game, :prefix => true

###
# Validators
###
  validates :community, :presence => true
  validates :game, :presence => true
  validates :name, :presence => true

###
# Callbacks
###
  after_create :make_game_announcement_space

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
  # The method creates the game specific announcement space.
  ###
  def make_game_announcement_space
    if !self.game_announcement_space
      space = DiscussionSpace.new(:name => "#{self.name} #{self.game_name} Announcements")
      if space
        space.community = self.community
        space.game = self.game
        space.is_announcement = true
        space.save!
        self.game_announcement_space = space
        self.save
      else
        logger.error("Could not create game announcement space for SupportedGame #{self.to_yaml}")
      end
    end
  end
end



# == Schema Information
#
# Table name: supported_games
#
#  id                         :integer         not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  game_announcement_space_id :integer
#  name                       :string(255)
#  game_type                  :string(255)
#

