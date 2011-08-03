=begin
  Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Don't Steal Me Bro!
  
  This class represents a Character Proxy.
=end
class CharacterProxy < ActiveRecord::Base
  
  belongs_to :game_profile
  belongs_to :character, :polymorphic => true, :autosave => true
  
  #TODO validate game_profile. Because of our creation design does this need to happen? If so it will need to be an after_create. -MO
  validates_presence_of :character
  
  after_create :default_gp_checker
  
=begin
  This method gets all characters, regardless of their game.
  [Returns] An array that contains all characters.
=end
  def self.all_characters
    CharacterProxy.all.collect!{|proxy| proxy.character}
  end
  
=begin
  This method gets the game profile for a character.
  [Args]
    * +character+ -> The character to use in the search.
  [Returns] An game_profile for the character argument, otherwise nil.
=end
  def self.character_game_profile(character)
    proxy = CharacterProxy.find_by_character_id(character)
    profile = proxy.game_profile if proxy
    profile
  end
  
=begin
  This method gets the active_profile_id for this character proxy.
  [Returns] The id of this character_proxy's game_profile.
=end  
  def active_profile_id
    self.game_profile.id
  end
  
=begin
  _after_create_

  This method is an after_create method that adds this character proxy to the default game profile.
=end
  def default_gp_checker
    self.game_profile.default_proxy_adder(self) if self.game_profile
  end
end

# == Schema Information
#
# Table name: character_proxies
#
#  id              :integer         not null, primary key
#  game_profile_id :integer
#  character_id    :integer
#  character_type  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

