###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an association between a game and a community that plays it.
###
class CommunityGame < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :game, :game_name, :faction, :server_name, :server_type

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
  delegate :admin_profile_id, to: :community, prefix: true, allow_nil: true

  delegate :factions, to: :game, allow_nil: true
  delegate :server_array, to: :game, allow_nil: true
  delegate :server_names, to: :game, allow_nil: true
  delegate :server_types, to: :game, allow_nil: true

###
# Validators
###
  validates :community, presence: true
  validates :game, presence: true

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
  # Search for community games by game name.
  def self.search_by_game_name(search)
    game_name = "%#{search}%"
    CommunityGame.joins{game}.where{(games.name =~ game_name) | (games.aliases =~ game_name)}
  end

###
# Instance Methods
###
  # Gets the smart name
  def smart_name
    number_of_community_games_with_same_game = CommunityGame.where(community_id: self.community_id, game_id: self.game_id).limit(2).count
    if number_of_community_games_with_same_game > 1
      self.full_name
    else
      self.game_name
    end
  end

  # Returns the full name of this game including game type faction and server.
  def full_name
    f_name = self.game_name
    f_name = f_name + " (#{self.faction})" if self.faction.present?
    f_name = f_name + " #{self.server_name}" if self.server_name.present?
    f_name = f_name + " - #{self.server_type}" if self.server_type.present?
    f_name
  end

  def game_name
    game.try(:name)
  end

  def game_name=(name)
    if name.present?
      some_game = Game.where(name: name).first
      some_game = CustomGame.where(name: name).first_or_create if some_game.blank?
      self.game = some_game
    end
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

