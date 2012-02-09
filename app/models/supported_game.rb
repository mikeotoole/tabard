###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an association between a game and a community that participates (supports) it.
###
class SupportedGame < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  MAX_NAME_LENGTH = 20

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :game_id, :game_type, :game

###
# Associations
###
  belongs_to :community
  belongs_to :game, :polymorphic => true
  has_many :roster_assignments

###
# Delegates
###
  delegate :name, :to => :game, :prefix => true
  delegate :name, :to => :community, :prefix => true
  delegate :faction, :to => :game, :allow_nil => true
  delegate :server_name, :to => :game, :allow_nil => true
  delegate :admin_profile_id, :to => :community, :prefix => true, :allow_nil => true
  delegate :all_factions, :to => :game, :allow_nil => true
  delegate :all_servers, :to => :game, :allow_nil => true

###
# Validators
###
  validates :community, :presence => true
  validate :game_faction_server_combination
  validates :name, :presence => true,
                   :length => { :maximum => MAX_NAME_LENGTH },
                   :uniqueness => {:case_sensitive => false, :scope => [:community_id, :game_id, :game_type, :deleted_at], :message => "exists for this exact game."}

###
# Public Methods
###

###
# Instance Methods
###

  # Gets the full name of this game with type faction and server
  def full_name
    "#{self.game_name} \u2014 #{self.name}"
  end

  # Gets the smart name
  def smart_name
    self.full_name
  end

###
# Protected Methods
###
protected

###
# Validator Methods
###

  ###
  # _validator_
  #
  # Makes sure that there is a game for the given faction server combination.
  ###
  def game_faction_server_combination
    if self.game_id.blank?
      game_class = self.game_type.constantize if self.game_type
      if game_class and game_class.superclass.name == "Game"
        self.errors.add(:server_name, "invalid for game type") if not game_class.all_servers.include?(self.server_name)
        self.errors.add(:faction, "invalid for game type") if not game_class.all_factions.include?(self.faction)
      else
        self.errors.add(:game_type, "is not valid")
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
#  deleted_at                 :datetime
#

