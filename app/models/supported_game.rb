###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an association between a game and a community that participates (supports) it.
###
class SupportedGame < ActiveRecord::Base
  validates_lengths_from_database except: [:name]
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  MAX_NAME_LENGTH = 20

###
# Attribute accessor
###
  attr_accessor :server_name, :faction, :server_type

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :game_id, :game_type, :game, :server_name, :faction, :server_type

###
# Associations
###
  belongs_to :community
  belongs_to :game, polymorphic: true
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
  delegate :full_name, to: :game, prefix: true
  delegate :short_name, to: :game, prefix: true
  delegate :name, to: :community, prefix: true
  delegate :admin_profile_id, to: :community, prefix: true, allow_nil: true

  delegate :faction, to: :game, allow_nil: true
  delegate :server_name, to: :game, allow_nil: true
  delegate :server_type, to: :game, allow_nil: true
  delegate :all_factions, to: :game, allow_nil: true
  delegate :all_servers, to: :game, allow_nil: true
  delegate :all_server_types, to: :game, allow_nil: true

###
# Validators
###
  validates :community, presence: true
  validate :game_attributes_valid
  validates :name, presence: true,
                   length: { maximum: MAX_NAME_LENGTH },
                   uniqueness: {case_sensitive: false, scope: [:community_id, :game_id, :game_type, :deleted_at], message: "exists for this exact game."}
  validates :game, presence: true

###
# Public Methods
###

  def self.attempt_to_match_type(term)
    regex = Regexp.new(term.downcase.gsub(/\s+/, "|"))
    return "Swtor" if regex =~ "swtor" or regex =~ "star wars the old republic"
    return "Minecraft" if regex =~ "minecraft"
    return "Wow" if regex =~ "wow" or regex =~ "world of warcraft"

    return term
  end

###
# Instance Methods
###
  # Gets the full name of this game with type faction and server
  def full_name
    "#{self.game_full_name} \u2014 #{self.name}"
  end

  # Gets the smart name
  def smart_name
    supported_games_of_same_type = self.community.supported_games.where(game_type: self.game_type)
    if supported_games_of_same_type.count == 1
      self.game_short_name
    else
      self.full_name
    end
  end

  # Gets the user_profiles of
  def member_profiles
    self.community.member_profiles_for_supported_game(self)
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
      self.community.action_items.delete(:add_supported_game)
      self.community.save
    end
  end
end

# == Schema Information
#
# Table name: supported_games
#
#  id                         :integer          not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  game_announcement_space_id :integer
#  name                       :string(255)
#  game_type                  :string(255)
#  deleted_at                 :datetime
#

