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
###
# Attribute accessible
###
  attr_accessible :about, :avatar, :remote_avatar_url, :info, :name, :type, :played_game_id

###
# Associations
###
  belongs_to :played_game
  has_one :user_profile, through: :played_game

###
# Delegates
###
  delegate :game, to: :played_game
  delegate :name, to: :game, prefix: true

###
# Validators
###

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
# Instance Methods
###
  # This method determines if this character proxy is compatable with the provided community.
  def compatable_with_community?(community)
    return community.community_games.exists?(game_id: self.game.id) if community
  end

  # This method determines if this character proxy is compatable with the provided community_game.
  def compatable_with_community_game?(community_game)
    return true if community_game == nil
    return community_game.game_type == self.game.class.to_s
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
#

