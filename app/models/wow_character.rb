=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a World of Warcraft character.
=end
class WowCharacter < BaseCharacter
  attr_accessor :avatar, :avatar_cache
  #attr_accessible :name, :faction, :race, :level, :server, :game, :discussion
  
  belongs_to :wow, :foreign_key => :game_id
  
  validates_presence_of :wow
  
  #uploaders
  mount_uploader :avatar, AvatarUploader
  #uploader helper
  def remove_avatar!
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
    end
  end
  def remove_previously_stored_avatar
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
      @previous_model_for_avatar = nil
    end
  end
  
  def display_name
    self.name
  end
  
  def game
    self.wow
  end
  
  def description
    "WoW Character"
  end  
  
end

# == Schema Information
#
# Table name: wow_characters
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  faction       :string(255)
#  race          :string(255)
#  level         :integer
#  server        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  game_id       :integer
#  discussion_id :integer
#  avatar        :string(255)
#

