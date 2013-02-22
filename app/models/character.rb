###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Game. Only subclasses of this should be created.
###
class Character < ActiveRecord::Base
###
# Constants
###
  #VALID_CHARACTERS = [['World of Warcraft', 'Wow'], ['Star Wars: The Old Republic', 'Swtor'], ['Minecraft', 'Minecraft'], ['Custom Game', 'CustomGame']]
  # Used by validator to limit the length of name.
  MAX_NAME_LENGTH = 50
  DEFAULT_AVATAR_CLASSES = %w( MinecraftCharacter )

###
# Attribute accessible
###
  attr_accessible :about, :avatar, :remote_avatar_url, :remove_avatar, :info, :name, :type, :played_game_id

###
# Associations
###
  belongs_to :played_game
  has_one :user_profile, through: :played_game
  has_many :announcements, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :discussions, dependent: :nullify
  has_many :invites, dependent: :nullify
  has_many :roster_assignments, dependent: :destroy
  has_and_belongs_to_many :community_applications


###
# Delegates
###
  delegate :game, to: :played_game
  delegate :game_type, to: :played_game
  delegate :name, to: :game, prefix: true
  delegate :id, to: :game, prefix: true
  delegate :gamer_tag, to: :user_profile, prefix: true
  delegate :display_name, to: :user_profile, prefix: true

###
# Validators
###
  validates :name,  presence: true,
                    length: { maximum: MAX_NAME_LENGTH }
  validates :played_game,  presence: true
  validates :avatar,
      if: :avatar?,
      file_size: {
        maximum: 5.megabytes.to_i
      }

###
# Public Methods
###

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

###
# H-Store
###
  # Setup info to use Hstore. This should not be needed for Rails 4.
  serialize :info, ActiveRecord::Coders::Hstore

###
# Class Methods
###
  ###
  # Lets the subclasses use the parents routes.
  # [Args]
  #   * +child+ -> The class to check if subclass.
  # [Returns] If is subclass of Game returns Character as model name.
  ###
  def self.inherited(child)
    child.instance_eval do
      # Defines the subclasses model name as its base class Game.
      def model_name
        Character.model_name
      end
    end
    super
  end

  ###
  # This method returns a search scoped or simply scoped search helper
  # [Args]
  #   * +search+ -> The string search for.
  # [Returns] A scoped query
  ###
  def self.search(search)
    if search
      search = "%"+search+'%'
      where{(name =~ search) | (about =~ search)}
    else
      scoped
    end
  end


###
# Instance Methods
###
  # This method determines if this character proxy is compatable with the provided community.
  def compatable_with_community?(community)
    return community.community_games.exists?(game_id: self.game.id) if community
  end

  def is_disabled?
    self.is_removed or self.user_profile.is_disabled?
  end

  # This method determines if this character proxy is compatable with the provided community_game.
  def compatable_with_community_game?(community_game)
    return true if community_game == nil
    return community_game.game_type == self.game.class.to_s
  end

  ###
  # This method is added for removing an avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
  ###
  def remove_avatar!
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
    end
  end

  ###
  # This method is added for removing a previously stored avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
  ###
  def remove_previously_stored_avatar
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
      @previous_model_for_avatar = nil
    end
  end
end

# == Schema Information
#
# Table name: characters
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  avatar         :string(255)
#  about          :text
#  played_game_id :integer
#  info           :hstore
#  type           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_removed     :boolean
#

