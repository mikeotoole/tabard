###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Character Proxy.
###
class CharacterProxy < ActiveRecord::Base
###
# Associations
###
  belongs_to :user_profile
  belongs_to :character, :polymorphic => true, :dependent => :destroy
  has_many :roster_assignments, :dependent => :destroy
  has_many :community_profiles, :through => :roster_assignments
  has_and_belongs_to_many :community_applications

###
# Validators
###
  validates :user_profile, :presence => true
  validates :character_id, :presence => true
  validates :character_type, :presence => true

###
# Delegates
###
  delegate :name, :to => :character
  delegate :game, :to => :character
  delegate :game_id, :to => :character
  delegate :game_name, :to => :character
  delegate :avatar_url, :to => :character, :allow_nil => true

###
# Public Methods
###

###
# Class Methods
###
  ###
  # This method gets all characters, regardless of their game.
  # [Returns] An array that contains all characters.
  ###
  def self.all_characters
    CharacterProxy.all.collect!{|proxy| proxy.character}
  end

  # This method determines if this character proxy is compatable with the provided community.
  def compatable_with_community?(community)
    community.supported_games.exists?(:game_type => self.game.class.to_s) if community
  end

###
# Instance Methods
###
  # Overrides the destroy to only mark as deleted and removes character from any rosters.
  def destroy
    self.character.destroy
  end
end




# == Schema Information
#
# Table name: character_proxies
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  character_id    :integer
#  character_type  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  is_removed      :boolean         default(FALSE)
#

