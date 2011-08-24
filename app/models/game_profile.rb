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

=begin
  This method gets the id for the game that this game profile belongs to.
  [Returns] An integer that contains the id of the game that this game profile belongs to, if possible. Otherwise false.
=end
  def game_id
    return game.id if game
    nil
  end

=begin
  This method gets all of the characters attached to this game profile.
  [Returns] An array that contains all of the characters attached to this game profile.
=end
  def characters
    characters = Array.new()
    for proxy in self.character_proxies
        characters << proxy.character
    end
    characters
  end

=begin
  This method gets the display name for this game profile.
  [Returns] A string that contains the default character name, if possible. Otherwise a default name based on the game.
=end
  def display_name
    self.default_character ? self.default_character.name : self.game.name.to_s + "Default Name"
  end

=begin
  This method gets the default character for this game profile.
  [Returns] The default character for this game profile, if possible. Otherwise nil.
=end
  def default_character
    return self.default_character_proxy.character if self.default_character_proxy
    nil
  end

=begin
  This method sets the default character.
  [Args]
    * +character+ -> A character to set as the default character.
  [Returns] True if the operation succeeded, otherwise false.
=end
  def default_character=(character)
    # TODO Add code to make this ensure that the character is really one that belongs to this game profile. - JW
    self.default_character_proxy = character.character_proxy
  end

=begin
  This method adds the character proxy's character as the default character.
  [Args]
    * +character_proxy+ -> The character proxy that you would like to make the default character.
  [Returns] True if opperation was preformed successfully, otherwise false.
=end
  def default_proxy_adder(character_proxy)
    # TODO Improve this logic.
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

