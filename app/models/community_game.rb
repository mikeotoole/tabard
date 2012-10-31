###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an association between a game and a community that plays it.
###
class CommunityGame < ActiveRecord::Base
  validates_lengths_from_database except: [:name]
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

  attr_accessor :name

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :game_id, :game, :name, :faction, :server_name, :server_type

###
# Associations
###
  belongs_to :community
  belongs_to :game
  has_many :roster_assignments, dependent: :destroy
  has_many :announcements, dependent: :destroy
  has_many :discussion_spaces, dependent: :destroy
  has_many :page_spaces, dependent: :destroy
  has_many :events, dependent: :destroy

###
# Callbacks
###
  after_create :remove_action_item

###
# Delegates
###
  delegate :name, to: :community, prefix: true
  delegate :name, to: :game, allow_nil: true
  delegate :admin_profile_id, to: :community, prefix: true, allow_nil: true

  delegate :factions, to: :game, allow_nil: true
  delegate :servers, to: :game, allow_nil: true
  delegate :server_names, to: :game, allow_nil: true
  delegate :server_types, to: :game, allow_nil: true

###
# Validators
###
  validates :community, presence: true
  validate :game_attributes_valid
  validates :game, presence: true
  # TODO: Add validation of server, faction, and server_type based on game.

###
# H-Store
###
  # Setup info to use Hstore. This should not be needed for Rails 4.
  serialize :info, ActiveRecord::Coders::Hstore

  # Dynamicly add setter, getter, and scopes for keys (See lib/hstore_accessor.rb).
  hstore_accessor :info, :faction, :server_name, :server_type

###
# Public Methods
###

###
# Instance Methods
###
  # Gets the full name of this game with type faction and server
  def full_name
    f_name = self.name
    f_name = f_name + " (#{self.faction})" if self.faction.present?
    f_name = f_name + " #{self.server_name}" if self.server_name.present?
    f_name = f_name + " - #{self.server_type}" if self.server_type.present?
    f_name
  end

  # Gets the smart name
  def smart_name
    # TODO: Fix this. -MO
#     community_games_of_same_type = self.community.community_games.where(game_type: self.game_type)
#     if community_games_of_same_type.any?
#       self.game_short_name
#     else
#       self.game_full_name
#     end
    self.full_name
  end

  # Returns the full name of this game including game type faction and server.
  def game_full_name
#     "World of Warcraft (#{self.faction}) #{self.server_name}" #TODO: Fix game_full_name -MO
    "#{self.name} (#{self.faction}) #{self.server_name}"
  end

  # Gets the user_profiles of
  def member_profiles
    self.community.member_profiles_for_community_game(self)
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
  # Makes sure that there is a game for the given game attributes.
  ###
  def game_attributes_valid
    if self.game_id.blank?
      if self.game and (self.game_type == "Wow" or self.game_type == "Swtor")
        self.errors.add(:server_name, "invalid for game type") if not self.all_servers.include?(self.server_name)
        self.errors.add(:faction, "invalid for game type") if not self.all_factions.include?(self.faction)
      elsif self.game and self.game_type == "Minecraft"
        self.errors.add(:server_type, "invalid for game type") if not self.all_server_types.include?(self.server_type)
      else
        self.errors.add(:game_type, "is not valid")
      end
    end
  end

###
# Callback Methods
###
  ###
  # _after_create_
  #
  # This method removes action item from community.
  ###
  def remove_action_item
    if self.community.action_items.any?
      self.community.action_items.delete(:add_community_game)
      self.community.save
    end
  end
end

# == Schema Information
#
# Table name: community_games
#
#  id                         :integer          not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  game_announcement_space_id :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  deleted_at                 :datetime
#  info                       :hstore
#

