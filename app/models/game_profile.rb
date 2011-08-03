=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a game profile.
=end
class GameProfile < Profile
  #attr_accessible :name, :game, :character_proxies, :user_profile, :default_character_proxy
  
  has_many :character_proxies, :dependent => :destroy, :autosave => true
  belongs_to :game
  belongs_to :user_profile
  
  belongs_to :default_character_proxy, :class_name => "CharacterProxy"
  
  validates_presence_of :user_profile, :game
  
  def game_id
    game.id
  end
  
  def characters
    characters = Array.new()
    for proxy in self.character_proxies
        characters << proxy.character
    end
    characters
  end
  
  def display_name
    self.default_character ? self.default_character.name : self.game.name.to_s + "Default Name"
  end
  
  def displayname
    self.display_name
  end
  
  def default_character
    self.default_character_proxy.character if self.default_character_proxy
  end
  
  def default_character=(character)
    self.default_character_proxy = character.character_proxy
  end
  
  def self.users_game_profile(userprofile, game)
    @gameprofile = GameProfile.find_by_user_profile_id_and_game_id(userprofile.id, game.id) if userprofile and game
  end
  
  def default_proxy_adder(character_proxy)
    unless self.default_character_proxy
      self.default_character_proxy = character_proxy
      self.save
    end
  end
  
end

# == Schema Information
#
# Table name: profiles
#
#  id                           :integer         not null, primary key
#  name                         :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  type                         :string(255)
#  user_id                      :integer
#  game_id                      :integer
#  user_profile_id              :integer
#  discussion_id                :integer
#  personal_discussion_space_id :integer
#  default_character_proxy_id   :integer
#  is_system_profile            :boolean
#  avatar                       :string(255)
#

